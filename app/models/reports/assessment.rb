class Reports::Assessment
  attr_reader :assessment, :year

  def initialize(form_answer, assessment, year)
    @assessment = assessment
    @form_answer = form_answer
    @year = year
  end

  def call_method(method_name)
    return "not implemented" if method_name.blank?

    if respond_to?(method_name, true)
      public_send(method_name)
    elsif @form_answer.respond_to?(method_name)
      @form_answer.public_send(method_name)
    elsif method_name.starts_with?("na_")
      if @assessment
        @assessment.document[(method_name.gsub(/(^na_)|(_\d$)/, ''))]
      else
        ""
      end
    else
      "missing method"
    end
  end

  def fetch(method_name)
    if method_name == "assessor_name"
      assessment.assessor.full_name
    else
      assessment.document[method_name]
    end
  end

  def ceremonial_county
    @form_answer.ceremonial_county.try(:name)
  end
end

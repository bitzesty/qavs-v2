class Reports::QavsBase
  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def build
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
     csv << headers
      @scope.each do |form_answer|
        nomination = build_nomination(form_answer)

        csv << mapping.map do |m|
          sanitize_string(
            nomination.call_method(m[:method])
          )
        end
      end
    end
  end

  private

  def build_nomination(form_answer)
    Reports::Nomination.new(form_answer)
  end

  def headers
    mapping.map { |m| m[:label] }
  end

  def sanitize_string(string)
    if string.present?
      ActionView::Base.full_sanitizer.sanitize(string.to_s.tr("\n","").squish)
    else
      ""
    end
  end
end

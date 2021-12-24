class Reports::Assessment
  attr_reader :assessment, :year

  def initialize(assessment, year)
    @assessment = assessment
    @year = year
  end

  def fetch(method_name)
    if method_name == "assessor_name"
      assessment.assessor.full_name
    else
      assessment.document[method_name]
    end
  end
end

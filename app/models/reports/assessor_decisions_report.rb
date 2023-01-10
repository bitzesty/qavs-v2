# coding: utf-8
class Reports::AssessorDecisionsReport < Reports::QavsBase
  attr_reader :year

  def initialize(scope, award_year, assessor)
    @scope = scope
    @year = award_year.year
    @assessor = assessor
  end

  def build
    CSV.generate(encoding: "UTF-8", force_quotes: true) do |csv|
     csv << headers
      @scope.each do |form_answer|
        assessment = build_assessment(form_answer, @assessor)

        csv << mapping.map do |m|
          sanitize_string(
            assessment.call_method(m[:method])
          )
        end
      end
    end
  end

  MAPPING = [
    {
      label: "Group name",
      method: :company_or_nominee_name
    },
    {
      label: "Ceremonial county",
      method: :ceremonial_county
    }
  ]

  SUBMITTED = [
    {
      label: "Submitted",
      method: :submitted?
    }
  ]

  private

  def assessment_data
    data = []

    questions = AppraisalForm.const_get("QAVS_#{year}")
    questions.each do |key, options|
      case options[:type]
      when :rag
        data << {
          label: "#{options[:label]} evaluation",
          method: "na_#{key}_rate"
        }

        data << {
          label: "#{options[:label]} comments",
          method: "na_#{key}_desc"
        }
      when :verdict
        data << {
          label: "#{options[:label]}",
          method: "na_#{key}_rate"
        }

        data << {
          label: "#{options[:label]} comments",
          method: "na_#{key}_desc"
        }
      end
    end

    data
  end

  def mapping
    MAPPING + assessment_data + SUBMITTED
  end

  def build_assessment(form_answer, assessor)
    assessment = form_answer.assessor_assignments.where(assessor_id: assessor.id).first

    Reports::Assessment.new(form_answer, assessment, year)
  end
end

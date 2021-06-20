require 'rails_helper'

describe "CaseSummaryPdfs::Base" do
  let!(:award_year) do
    AwardYear.current
  end
  let!(:support_letter_attachment) { FactoryBot.create :support_letter_attachment }
  let!(:support_letter) { FactoryBot.create :support_letter, support_letter_attachment: support_letter_attachment }

  let!(:form_answer_current_year) do
    FactoryBot.create :form_answer, :recommended, award_year: award_year, support_letters: [support_letter]
  end

  before do
    form_answer = form_answer_current_year
    create :assessor_assignment, form_answer: form_answer,
           submitted_at: Date.today,
           assessor: nil,
           position: "case_summary",
           document: set_case_summary_content(form_answer)
  end

  describe "#set_form_answers" do
    it "should be ordered in year and filtered by category" do
      case_summaries = CaseSummaryPdfs::Base.new(
        "all", nil, {
          award_year: award_year,
          years_mode: "3"
        }
      ).set_form_answers
       .map(&:id)

      expect(case_summaries).to match_array([
        form_answer_current_year.id
      ])
    end
  end

  private

  def set_case_summary_content(form_answer)
    res = {}

    AppraisalForm.struct(form_answer).each do |key, value|
      res["#{key}_desc"] = "Lorem Ipsum"
      res["#{key}_rate"] = ["negative", "positive", "average"].sample
    end

    res
  end
end

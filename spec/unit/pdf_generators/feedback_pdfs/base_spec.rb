require 'rails_helper'

describe "FeedbackPdfs::Base" do
  let!(:award_year) do
    AwardYear.current
  end

  let!(:form_answer) do
    FactoryBot.create :form_answer, :submitted
  end

  before do
    create :feedback, submitted: true,
                      form_answer: form_answer,
                      document: set_feedback_content(form_answer)
  end

  describe "#set_feedbacks" do
    it "should be ordered in year and filtered by category" do
      feedbacks = FeedbackPdfs::Base.new(
        "all", nil, {
          award_year: award_year
        }
      ).set_feedbacks
       .map(&:id)

      expect(feedbacks).to match_array([
        form_answer.feedback.id,
      ])
    end
  end

  private

  def set_feedback_content(form_answer)
    res = {}

    FeedbackForm.fields_for_award_type(form_answer).each_with_index do |block, index|
      key = block[0]
      res["#{key}_strength"] = "#{index}_strength"
      res["#{key}_weakness"] = "#{index}_weakness"
    end

    res
  end
end

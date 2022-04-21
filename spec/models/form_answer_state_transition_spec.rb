require "rails_helper"

describe FormAnswerStateTransition do
  let(:form_answer) { create(:form_answer, :submitted, :shortlisted) }

  describe "#collection" do
    before do
      subject.form_answer = form_answer

      deadline = form_answer.award_year.settings.deadlines.submission_end.first
      deadline.update_column(:trigger_at, Time.zone.now - 2.days)
    end

    it "returns final verdict states for admin" do
      admin = create(:admin)

      subject.subject = admin

      expected = [
        :shortlisted,
        :not_recommended,
        :no_royal_approval,
        :undecided,
        :awarded
      ]

      expect(subject.collection).to eq(expected)
    end
  end
end

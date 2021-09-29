require "rails_helper"

describe FormAnswerStateTransition do
  let(:form_answer) { create(:form_answer, :submitted, :shortlisted) }

  describe "#collection" do
    before do
      subject.form_answer = form_answer

      allow(Settings).to receive(:after_current_submission_deadline?).and_return(true)
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

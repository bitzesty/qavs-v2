require "rails_helper"

describe FormAnswerStateTransition do
  let(:form_answer) { create(:form_answer, :submitted, state: :recommended) }

  describe "#collection" do
    before do
      subject.form_answer = form_answer

      allow(Settings).to receive(:after_current_submission_deadline?).and_return(true)
    end

    it "returns all states for admin" do
      admin = create(:admin)

      subject.subject = admin

      expected = [
        :admin_not_eligible,
        :admin_eligible,
        :local_assessment_in_progress,
        :local_assessment_recommended,
        :local_assessment_not_recommended,
        :assessment_in_progress,
        :recommended,
        :reserved,
        :not_recommended,
        :disqualified,
        :awarded,
        :not_awarded,
        :withdrawn
      ]

      expect(subject.collection).to eq(expected)
    end
  end
end

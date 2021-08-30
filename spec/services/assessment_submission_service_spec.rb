require "rails_helper"

describe AssessmentSubmissionService do
  include FormAnswerTestMethods

  let(:assessor) { create(:assessor) }
  let(:form_answer) { create(:form_answer, :local_assessment_recommended, sub_group: assessor.sub_group) }

  subject { described_class.new(assessment, assessor) }

  context "submission" do
    let!(:assessment) { create(:assessor_assignment, :valid_for_submission, form_answer: form_answer, assessor: assessor) }

    it "submits the assignment and locks it" do
      expect { subject.perform }.to change { assessment.submitted? }.from(false).to(true)

      expect(assessment.locked_at).to be
    end
  end
end

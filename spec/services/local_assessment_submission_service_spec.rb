require "rails_helper"

describe LocalAssessmentSubmissionService do
  let(:ll) { create(:lieutenant) }
  let(:nomination) { create(:form_answer, :submitted) }
  let!(:settings) { create(:settings, :expired_submission_deadlines) }

  before do
    nomination.update_column(:state, "local_assessment_in_progress")
  end

  it "marks nomination as recommended by LL" do
    nomination.document = nomination.document.merge("local_assessment_verdict" => "recommended")
    nomination.save!

    LocalAssessmentSubmissionService.new(nomination, ll).submit!

    expect(nomination.reload.state).to eq("local_assessment_recommended")
  end

  it "marks nomination as not recommended by LL" do
    nomination.document = nomination.document.merge("local_assessment_verdict" => "not_recommended")
    nomination.save!

    LocalAssessmentSubmissionService.new(nomination, ll).submit!

    expect(nomination.reload.state).to eq("local_assessment_not_recommended")
  end
end

require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Assessor::AssessmentSubmissionsController do
  let!(:assessor) { create(:assessor) }
  let!(:form_answer) { create(:form_answer, sub_group: assessor.sub_group) }
  let!(:assessor_assignment) { create(:assessor_assignment, :valid_for_submission, form_answer: form_answer, assessor_id: assessor.id) }

  before do
    sign_in assessor
    allow_any_instance_of(AssessorAssignment).to receive(:locked?) { true }
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(AssessmentSubmissionService).to receive(:perform) {}
      post :create, params: { assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:assessor, assessor_assignment.form_answer]
    end
  end
end

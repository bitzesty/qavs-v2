require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe Admin::AssessmentSubmissionsController do
  let!(:admin) { create(:admin) }
  let!(:assessor_assignment) { create(:assessor_assignment, :valid_for_submission) }

  before do
    sign_in admin
  end

  describe "POST create" do
    it "should create a resource" do
      allow_any_instance_of(AssessmentSubmissionService).to receive(:perform) {}
      post :create, params: { assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
    end
  end

  describe "PATCH unlonk" do
    it "should unlock a resource" do
      allow_any_instance_of(AssessorAssignment).to receive(:locked?) {true}

      patch :unlock, params: { id: assessor_assignment.id, assessment_id: assessor_assignment.id }
      expect(response).to redirect_to [:admin, assessor_assignment.form_answer]
      expect(assessor_assignment.reload.locked_at).to be_nil
    end
  end
end

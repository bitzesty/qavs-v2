require 'rails_helper'

describe Users::FormAnswersController do
  describe "logging" do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    let!(:form_answer) do
      create :form_answer,
             user: user,
             document: { company_name: "Bitzesty" }
    end

    it "should create log entry" do
      sign_in(form_answer.user)

      allow_any_instance_of(ApplicationController).to receive(:current_admin).and_return(admin)

      expect {
        get :show, params: { id: form_answer.id }, format: :pdf, session: {admin_in_read_only_mode: true }
      }.to change { AuditLog.count }.by(1)

      log = AuditLog.last

      expect(log.subject).to eq(admin)
      expect(log.auditable).to eq(form_answer)
      expect(log.action_type).to eq("download_form_answer")
    end
  end
end

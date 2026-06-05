require 'rails_helper'
include Warden::Test::Helpers

describe "Assessor: Download original pdf of application at the deadline", %q{
As an Assessor (Lead / Primary)
I want to download original PDF of application at the deadline
So that I can see original application data was at the deadline moment
} do
  let!(:form_user) { create(:user) }
  let!(:form_answer) { create(:form_answer, :submitted, user: form_user) }

  let(:target_url) do
    assessor_form_answer_path(form_answer)
  end

  before do
    Settings.current_submission_deadline.update(trigger_at: Time.zone.now - 1.day)
    # Generate the PDF version
    form_answer.generate_pdf_version!
  end

  describe "Lead Assessor" do
    let!(:lead_assessor) { create(:assessor, :lead_for_all) }

    before do
      login_as(lead_assessor, scope: :assessor)
    end

    it_behaves_like "download original pdf before deadline ends"
  end

  # Skip because removed trait regular_for_trade from form answer
  describe "Primary Assessor", skip: true do
    let!(:primary_assessor) { create(:assessor, :regular_for_trade) }
    let!(:primary) { form_answer.assessor_assignments.primary }

    before do
      primary.assessor = primary_assessor
      primary.save

      login_as(primary_assessor, scope: :assessor)
    end

    it_behaves_like "download original pdf before deadline ends"
  end
end

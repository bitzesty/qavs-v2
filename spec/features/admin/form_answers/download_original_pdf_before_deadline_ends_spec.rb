require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download original pdf of application at the deadline", %q{
As an Admin
I want to download original PDF of application at the deadline
So that I can see original application data was at the deadline moment
} do
  let!(:form_user) { create(:user) }
  let!(:form_answer) { create(:form_answer, :submitted, user: form_user) }
  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)

    Settings.current_submission_deadline.update(trigger_at: Time.zone.now - 1.day)
    # Generate the PDF version
    form_answer.generate_pdf_version!
  end

  it_behaves_like "download original pdf before deadline ends"
end

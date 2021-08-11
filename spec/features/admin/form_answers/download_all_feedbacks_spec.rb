require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download all Feedbacks as one pdf", %q{
As an Admin
I want to download all Feedbacks as one pdf per category from Dashboard
So that I can print and review application feedbacks
} do

  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  describe "Dashboard / Feedbacks section displaying" do
    before do
      visit downloads_admin_dashboard_index_path
    end

    xit "should be links to download feedbacks" do
      expect(page).to have_link('Download',
                                href: admin_report_path(
                                  id: "feedbacks",
                                  category: "qavs",
                                  format: :pdf,
                                  year: AwardYear.current.year))
    end
  end

  # describe "Feedback" do
  #   include_context "admin all feedbacks pdf generation"
  # end
end

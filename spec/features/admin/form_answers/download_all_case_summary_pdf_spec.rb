require 'rails_helper'
include Warden::Test::Helpers

describe "Admin: Download all Case Summary as one pdf", %q{
As an Admin
I want to download all Case Summary PDFS as one pdf per category from Dashboard
So that I can print and review application case summaries
} do

  let!(:admin) { create(:admin) }

  before do
    login_admin(admin)
  end

  describe "Dashboard / Case Summary section displaying" do
    before do
      visit downloads_admin_dashboard_index_path
    end

    it "should be links to download case summaries" do
      ops = {
        id: "case_summaries",
        category: "qavs", format: :pdf,
        year: AwardYear.current.year
      }


      expect(page).to have_link('Download',
                                href: admin_report_path(
                                  ops
                                )
                               )
    end
  end

  describe "QAVS" do
    include_context "admin all case summaries pdf generation"
  end
end

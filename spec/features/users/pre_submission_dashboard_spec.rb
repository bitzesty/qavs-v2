require "rails_helper"
include Warden::Test::Helpers

describe  "User sees the pre submission dashboard", js: true do
  let(:user) { create(:user, :completed_profile) }

  before do
    Settings.current_award_year_switch_date.update(trigger_at: 10.days.ago)
    login_as user
  end

  describe "when visits the dashboard after some awards are opened" do
    it "should see message confirming that" do
      visit dashboard_path
      expect(page).to have_link("Start a new nomination", href: "/apply_qavs_award")
      expect_to_be_accessible
    end
  end
end

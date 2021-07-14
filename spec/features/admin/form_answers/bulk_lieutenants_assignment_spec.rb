require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

# Skip because removed trait trade from form answer
describe "Admin assigns lieutenants", %(
  As Admin
  I want to be able to assign lieutenants
), js: true do

  let(:subject) { create(:admin) }
  let!(:settings) { create(:settings, :expired_submission_deadlines) }
  let!(:ceremonial_county_1) { create(:ceremonial_county, name: "A") }
  let!(:ceremonial_county_2) { create(:ceremonial_county, name: "B") }
  let!(:form_answer_1) { create(:form_answer, :submitted) }
  let!(:form_answer_2) { create(:form_answer, :submitted) }

  describe "Form submission" do
    before do
      login_as(subject, scope: :admin)
      visit admin_form_answers_path
    end

    it "assigns the lieutenant" do
      first("#check_all").set(true)

      find(".btn", text: "Bulk Assign Lieutenants").click

      open_county_select

      all(".select2-results__options li")[2].click

      within ".bulk-assign-lieutenants-form" do
        click_button "Assign"
      end

      expect(form_answer_1.reload.ceremonial_county.name).to eq("B")
      expect(form_answer_2.reload.ceremonial_county.name).to eq("B")
    end
  end
end

def open_county_select
  page.execute_script("$('#lieutenant_assignment_collection_ceremonial_county_id').select2('open');")
end

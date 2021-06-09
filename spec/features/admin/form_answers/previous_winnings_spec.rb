require "rails_helper"

include Warden::Test::Helpers
describe "Admin sets up previous winnings", skip: true do
  let!(:admin) { create(:admin) }

  before do
    Settings.current_submission_deadline.update(trigger_at: DateTime.now - 1.day)
    form_answer.update(submitted_at: Time.current)

    login_admin(admin)
    visit admin_form_answer_path(form_answer)
  end

  context "addition" do
    let!(:form_answer) { create(:form_answer) }

    pending "adds previous winning" do
      within ".previous-wins-form" do
        first("option[value='innovation']").select_option
        first("option[value='2014']").select_option
        find("input[type='submit']").click
      end
      within ".previous-wins-form" do
        expect(page).to have_selector(".well", count: 1)
        expect(page).to have_content("Innovation")
      end
    end
  end

  context "deletion" do
    let!(:form_answer) do
      form = create(:form_answer, :trade)

      form.document["applied_for_queen_awards_details"] = [
        {"category"=>"international_trade", "year"=>"2015", "outcome" => "won"},
        {"category"=>"international_trade", "year"=>"2015", "outcome" => "won"}
      ]
      form.update_column(:document, form.document)

      return form
    end

    pending "deletes previous winning" do
      within ".previous-wins-form" do
        expect(page).to have_selector(".well", count: 2)
        first("input[type='checkbox']").set(true)
        click_button "Save"
      end
      within ".previous-wins-form" do
        expect(page).to have_selector(".well", count: 1)
      end
    end
  end
end

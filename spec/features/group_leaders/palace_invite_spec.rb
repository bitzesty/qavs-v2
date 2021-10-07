require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

def enter_attendee_details(attendee)
  prefix = "palace_invite_palace_attendees_attributes_#{attendee-1}_"
  fill_in "#{prefix}relationship", with: "string"
  fill_in "#{prefix}first_name", with: "string"
  fill_in "#{prefix}last_name", with: "string"
  fill_in "#{prefix}address_1", with: "string"
  fill_in "#{prefix}postcode", with: "string"
  choose "#{prefix}disabled_access_true"
  choose "#{prefix}preferred_date_any"
  choose "#{prefix}alternative_date_any"
end

def enter_palace_attendees
  create(:email_notification, trigger_at: 1.day.ago, kind: "buckingham_palace_invite")

  click_link "Provide details for Royal Garden Party"

  expect(page).to have_content("Details for Royal Garden Party")

  enter_attendee_details(1)
  enter_attendee_details(2)
end

describe "Palace invite process" do
  let(:form_answer) { create(:form_answer) }
  let(:group_leader) { create(:group_leader, form_answer_id: form_answer.id) }

  before do
    create(:citation, form_answer_id: form_answer.id)
    login_group_leader(group_leader)
  end

  it "allows group leader to confirm palace attendees" do
    enter_palace_attendees
    check 'I confirm that I have received consent from each attendee to submit the data to the Queen’s Awards for Voluntary Service and The Royal Household.'
    click_button "Submit"

    expect(page).to have_selector("#flash-message-success-title", text: "Success")
  end

  it "does not allow submission unless consent given" do
    enter_palace_attendees

    click_button "Submit"

    expect(page).to have_content("Please confirm you have obtained both attendee's consent to provide their details")
  end
end

require 'rails_helper'
include Warden::Test::Helpers

describe "Lieutenant: Nomination process", js: true do
  let(:lieutenant) { create(:lieutenant,
                            :advanced,
                            first_name: "Poor",
                            last_name: "Yorick") }

  before do
    login_lieutenant(lieutenant)
  end

  it "allows lieutenant to continue nomination after it was submitted" do
    Settings.current_submission_deadline.update(trigger_at: 1.day.ago)
    fa = create(:form_answer, :admin_eligible, :with_support_letters, ceremonial_county_id: lieutenant.ceremonial_county_id)

    visit lieutenant_form_answers_path

    click_link "Bit Zesty"
    click_link "View nomination form"

    expect(page).to have_current_path edit_lieutenant_form_answer_path(fa)
    click_link("A. Nominee")
    expect(find_field("form[nominee_name]", disabled: true).value).to eq("Bit Zesty")
    expect_to_be_accessible

    click_link("E. Local Assessment Form")
    expect(find_field("form[nomination_local_assessment_form_nominee_name]", disabled: false).value).to eq("Bit Zesty")

    expect(page).to have_content("E. Local Assessment Form")
    expect_to_be_accessible
  end
end

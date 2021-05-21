require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Eligibility forms" do
  let!(:user) { create(:user, :completed_profile) }
  let!(:collaborator) { create(:user, :completed_profile, role: "regular", account: user.account) }

  before do
    create(:settings, :submission_deadlines)
    login_as(user, scope: :user)
  end

  context "innovation" do
    pending "process the eligibility form" do
      visit dashboard_path
      new_application("Innovation Award")
      # fill_in("nickname", with: "innovation nick")
      click_button("Save and start eligibility questionnaire")
      form_choice(["Yes", "Yes", "Yes", /Business/, /Product/, "Yes", "No", "Yes"])

      fill_in("How many innovative products, services or business models do you have?", with: 2)
      click_button "Continue"
      form_choice("Yes")
      form_choice("Yes")
      form_choice("Yes")
      expect(page).to have_content("You are eligible to begin your application")
      first('.previous-answers').click_link("Continue")
      expect(page).to have_content("You are eligible to begin your application for an Innovation Award.")
    end
  end
end

def form_choice(labels)
  label_ids = Array(labels)

  label_ids.each do |label_id|
    l = all(".question-body .selectable").detect do |label|
      if label_id.is_a?(String)
        label.text == label_id
      elsif label_id.is_a?(Regexp)
        label.text =~ label_id
      end
    end

    l.find("input").set(true)
    click_button "Continue"
  end
end

def new_application(type)
  header = find(".applications-list li h3", text: type)
  header.find(:xpath, '..').first("a").click
end

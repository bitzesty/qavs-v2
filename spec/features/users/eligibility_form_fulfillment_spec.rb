require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Eligibility forms" do
  let!(:user) { create(:user, :completed_profile) }

  before do
    AwardYear.current
    create(:settings, :submission_deadlines)
    login_as(user, scope: :user)
  end

  context "innovation" do
    it "process the eligibility form" do
      visit dashboard_path
      click_link("Start a new nomination")

      click_button("Start eligibility questionnaire")
      form_choice(%w[No Yes])
      expect(page).to have_content("How many years has the group been in operation?")
      fill_in("How many years has the group been in operation?", with: 3)
      click_button "Continue"
      form_choice(%w[Yes Yes No Yes No No No])
      expect(page).to have_content("Thank you. Based on your answers, the group meets the basic eligibility citeria. You can proceed with nominating.")
      first(".previous-answers").click_link("Continue")
      expect(page).to have_content("Useful Nomination Info Before You Begin")
    end
  end
end

def form_choice(labels)
  label_ids = Array(labels)

  label_ids.each do |label_id|
    l = all(".question-body .govuk-radios__item").detect do |label|
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

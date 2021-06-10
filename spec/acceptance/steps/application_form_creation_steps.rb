step "an eligible user exists" do
  @user = FactoryBot.create(:user, :eligible, password: "my98ssdkjv9823kds=2")
end

step "settings with submission deadlines exists" do
  FactoryBot.create(:settings, :submission_deadlines)
end

step "I am eligible user" do
  step "an eligible user exists"
  step "I sign in as user"
end

step "I go to dashboard" do
  visit '/dashboard'
end

step "I should see application link" do
  expect(page).to have_link("New application", href:'/apply_qavs_award')
end

step "I create nomination" do
  step "I go to dashboard"
  click_link "New application", href: '/apply_qavs_award'
  click_button "Start eligibility questionnaire"
  click_button "Continue" #eligibility step
end

step "I should see nomination form" do
  have_selector "form.qae_form"
end

step "I should see application edit link on dashboard" do
  step "I go to dashboard"
  expect(page).to have_link("Continue nomination")
end

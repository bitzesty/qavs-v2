require "rails_helper"
include Warden::Test::Helpers

describe "Form answer search", "
  As Admin
  I want to search by applications using bunch of attributes." do
  let!(:admin) { create(:admin) }

  before do
    create(:form_answer)
    login_admin admin
    visit admin_form_answers_path
  end

  context "success searching" do
    context "by user name" do
      let!(:user) { create(:user, first_name: first_name) }
      let(:first_name) { "user-#{rand(100000)}" }
      let!(:form_answer) { create(:form_answer, user: user) }

      it "searchs for form answer with first name" do
        within ".search-input" do
          fill_in "search_query", with: first_name
        end
        click_button "Apply filters"

        within ".applications-table tbody" do
          expect(page).to have_selector("tr", count: 1)
        end
      end
    end
  end
end

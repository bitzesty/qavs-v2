require "rails_helper"
include Warden::Test::Helpers

describe "Form answer list sorting", js: true do
  let!(:subject) { create(:admin) }

  before do
    3.times do |i|
      create :form_answer,
             document: { nominee_name: "#{i}",
                         nominee_activity: "SPO" }
    end

    login_as(subject, scope: :admin)
    visit admin_form_answers_path
  end

  it_behaves_like "form answers table sorting", 1
end

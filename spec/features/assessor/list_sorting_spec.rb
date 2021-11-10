require "rails_helper"
include Warden::Test::Helpers

# Skip because removed trait trade from form answer
describe "Form answer list sorting", js: true do
  let!(:assessor) { create(:assessor) }

  before do
    3.times do |i|
      fa = create(:form_answer,
                  :local_assessment_recommended,
                  sub_group: assessor.sub_group)

      fa.document = fa.document.merge("nominee_name" => i.to_s)
      fa.save!
    end

    login_as(assessor, scope: :assessor)
    visit assessor_form_answers_path
  end

  it_behaves_like "form answers table sorting"
end

require "rails_helper"
include Warden::Test::Helpers

Warden.test_mode!

# Skip because removed trait trade from form answer
describe "Assessor submits appraisal form", %(
  As Assessor
  I want to be able to edit, submit the appraisal form.
), js: true do

  let(:scope) { :assessor }
  let(:assessor) { create(:assessor) }
  let(:subject) { assessor }

  it_behaves_like "successful appraisal form edition"
end

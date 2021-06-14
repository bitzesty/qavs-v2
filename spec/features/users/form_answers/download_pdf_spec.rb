require 'rails_helper'
include Warden::Test::Helpers

describe "Download a pdf of the award form filled", %q{
As a User
I want to be able to download a pdf of the filled in form filled in with whatever I have entered so far
So that I can review my progress or share the pdf with others
} do

  let!(:user) do
    FactoryBot.create :user
  end

  before do
    login_as user
  end

  describe "QAVS" do
    let!(:form_answer) do
      FactoryBot.create :form_answer,
        user: user,
        document: { company_name: "Bitzesty" }
    end

    let(:pdf_filename) do
      form_answer.decorate.pdf_filename
    end

    before do
      visit users_form_answer_path(form_answer, format: :pdf)
    end

    it "should generate pdf" do
      expect(page.status_code).to eq(200)
      expect(page.response_headers["Content-Disposition"]).to include "attachment; filename=\"#{pdf_filename}\""
      expect(page.response_headers["Content-Type"]).to be_eql "application/pdf"
    end
  end
end

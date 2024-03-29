require "rails_helper"

describe Users::SubmissionMailer do
  let!(:user) { create :user }

  let(:form_answer) do
    FactoryBot.create :form_answer,
                      :submitted,
                      user: user
  end

  let(:subject) { "KAVS Nomination Received" }

  before do
    form_answer
  end

  describe "Email Me" do
    let(:mail) { Users::SubmissionMailer.success(user.id, form_answer.id) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{subject}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
    end
  end
end

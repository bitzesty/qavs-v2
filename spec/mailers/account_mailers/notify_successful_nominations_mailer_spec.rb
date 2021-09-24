require "rails_helper"

describe AccountMailers::NotifySuccessfulNominationsMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, :awarded, user: user }
  let(:mail) {
    AccountMailers::NotifySuccessfulNominationsMailer.notify(
      form_answer.id
    )
  }
  let(:subject) do
    "Your nomination for Queen’s Award for Voluntary Service"
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq subject
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]
      link = 'http://example.com/awardees'
      expect(mail.body.raw_source).to match group_name
      expect(mail.body.raw_source).to match("We are delighted to inform you that the group was recommended to Her Majesty")
      expect(mail.body.raw_source).to match link
    end
  end
end

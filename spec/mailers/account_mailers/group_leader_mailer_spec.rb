require "rails_helper"

describe AccountMailers::GroupLeaderMailer do
  let(:form_answer) { create :form_answer, :submitted }

  let(:mail) {
    AccountMailers::GroupLeaderMailer.notify(
      form_answer.id
    )
  }
  let(:subject) {
    "Nomination for King's Award for Voluntary Service"
  }
  let(:recipient) {
    form_answer.document["nominee_leader_email"]
  }

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq subject
      expect(mail.to).to eq([recipient])
      expect(mail.from).to eq(["no-reply@kavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_name = form_answer.document["nominee_name"]
      expect(mail.body.raw_source).to match(group_name)
      expect(mail.body.raw_source).to match("We are currently making checks to ensure the group is eligible.")
    end
  end
end

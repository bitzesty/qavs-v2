require "rails_helper"

describe GroupLeadersMailers::WinnersHeadOfOrganisationMailer do
  let(:form_answer) { create :form_answer, :awarded }

  let(:mail) {
    GroupLeadersMailers::UnsuccessfulNominationMailer.notify(
      form_answer.id
    )
  }

  describe "#notify" do
    it "renders the headers" do
      email = form_answer.document["local_assessment_group_leader_email"]
      expect(mail.to).to eq([email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match("I am sorry to say that in the end it was not among those selected to receive the Award this year.")
    end
  end
end

require "rails_helper"

describe GroupLeadersMailers::WinnersHeadOfOrganisationMailer do
  let(:form_answer) { create :form_answer, :awarded }
  let(:group_leader) { create :group_leader,
                              form_answer_id: form_answer.id,
                              email: form_answer.document["local_assessment_group_leader_email"] }

  let(:mail) {
    GroupLeadersMailers::WinnersHeadOfOrganisationMailer.notify(
      form_answer.id, group_leader.id
    )
  }
  let(:subject) {
    "Queen’s Award for Voluntary Service - in confidence"
  }

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq subject
      expect(mail.to).to eq([group_leader.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]
      expect(mail.body.raw_source).to match(group_name)
      expect(mail.body.raw_source).to match("Her Majesty The Queen has approved the QAVS National Assessment Committee’s recommendation")
    end
  end
end

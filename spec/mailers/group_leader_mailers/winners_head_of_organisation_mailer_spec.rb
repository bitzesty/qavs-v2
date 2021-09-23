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

  before do
    Settings.current_submission_deadline.update(trigger_at: 10.days.ago)
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([group_leader.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]
      expect(mail.body.raw_source).to match("We were delighted to receive a nomination for #{ group_name } for The Queen’s Award for Voluntary Service.")
    end
  end
end

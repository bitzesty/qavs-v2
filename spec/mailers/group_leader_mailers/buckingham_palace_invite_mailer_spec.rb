require "rails_helper"

describe GroupLeadersMailers::BuckinghamPalaceInviteMailer do
  let(:form_answer) { create :form_answer, :awarded }
  let(:group_leader) { create :group_leader,
                              form_answer_id: form_answer.id,
                              email: form_answer.document["local_assessment_group_leader_email"] }

  let(:mail) {
    GroupLeadersMailers::BuckinghamPalaceInviteMailer.notify(
      form_answer.id, group_leader.id
    )
  }
  let(:subject) {
    "QAVS Invitations to a Royal Garden Party - action required"
  }

  before do
    Settings.current_palace_reception_attendee_information_deadline.update(trigger_at: 10.days.from_now)
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq subject
      expect(mail.to).to eq([group_leader.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_leader_name = "#{ group_leader.first_name } #{ group_leader.last_name }"
      expect(mail.body.raw_source).to match group_leader_name
      expect(mail.body.raw_source).to match "We are writing to ask for details of the two volunteers who will represent your group."
    end
  end
end

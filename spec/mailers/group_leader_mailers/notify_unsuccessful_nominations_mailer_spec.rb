# coding: utf-8
require "rails_helper"

describe GroupLeadersMailers::NotifyUnsuccessfulNominationsMailer do
  let(:form_answer) { create :form_answer, :not_awarded }

  let(:mail) {
    GroupLeadersMailers::NotifyUnsuccessfulNominationsMailer.notify(
      form_answer.id
    )
  }
  let(:subject) {
    "Queen’s Award for Voluntary Service #{ form_answer.award_year.year }"
  }
  let(:recipient) {
    form_answer.document["local_assessment_group_leader_email"]
  }

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq subject
      expect(mail.to).to eq([recipient])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]
      expect(mail.body.raw_source).to match(group_name)
      expect(mail.body.raw_source).to match("I am sorry to say that in the end it was not among those selected to receive the award this year")
    end
  end
end

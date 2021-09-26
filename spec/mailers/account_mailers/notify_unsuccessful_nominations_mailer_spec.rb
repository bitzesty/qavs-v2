require "rails_helper"

describe AccountMailers::NotifyUnsuccessfulNominationsMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, :not_awarded, user: user }
  let(:mail) {
    AccountMailers::NotifyUnsuccessfulNominationsMailer.notify(
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
      puts form_answer.state
      group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]
      link = "https://www.gov.uk/honours"
      expect(mail.body.raw_source).to match group_name
      expect(mail.body.raw_source).to match "The standard was extremely high and, in the end, the group was not selected for the Award"
      expect(mail.body.raw_source).to match link
    end
  end
end

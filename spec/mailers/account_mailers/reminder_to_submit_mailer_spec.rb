require "rails_helper"

describe AccountMailers::ReminderToSubmitMailer do
  let(:user) { create :user }
  let(:form_answer) { create :form_answer, user: user }

  let(:mail) {
    AccountMailers::ReminderToSubmitMailer.notify(
      form_answer.id
    )
  }

  before do
    Settings.current_submission_deadline.update(trigger_at: 10.days.ago)
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@kavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(edit_form_url(id: form_answer.id))
    end
  end
end

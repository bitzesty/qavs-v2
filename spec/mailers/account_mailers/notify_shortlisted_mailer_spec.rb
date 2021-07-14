require "rails_helper"

# Skip because deadline kind "audit_certificates" doesn't currently exists
describe AccountMailers::NotifyShortlistedMailer, skip: true do
  let!(:user) { create :user }

  let(:form_answer) do
    create :form_answer, :submitted, user: user
  end

  let!(:deadline) do
    deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    deadline.update(trigger_at: Date.current)
    deadline.trigger_at.strftime("%d/%m/%Y")
  end

  let(:award_title) { form_answer.decorate.award_application_title }
  let(:subject) do
    "[Queen's Awards for Enterprise] Congratulations! You've been shortlisted!"
  end

  let(:mail) {
    AccountMailers::NotifyShortlistedMailer.notify(
      form_answer.id,
      user.id
    )
  }

  before do
    form_answer
  end

  describe "#notify" do
    it "renders the headers" do
      expect(mail.subject).to eq(subject)
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match(user.decorate.full_name)
      expect(mail.body.raw_source).to match(deadline)
    end
  end
end

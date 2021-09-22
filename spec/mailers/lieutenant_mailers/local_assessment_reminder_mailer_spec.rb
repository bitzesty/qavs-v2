require "rails_helper"

describe LieutenantsMailers::LocalAssessmentReminderMailer do
  let(:county) { create :ceremonial_county }
  let(:lieutenant) { create :lieutenant, ceremonial_county: county }
  let(:form_answer) { create :form_answer, ceremonial_county: county }

  let(:mail) {
    LieutenantsMailers::LocalAssessmentReminderMailer.notify(
      lieutenant.id
    )
  }

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([lieutenant.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      Settings.current_local_assessment_submission_deadline.update(trigger_at: 1.days.from_now)
      deadline = Settings.current_local_assessment_submission_deadline.strftime("%A %d %B %Y")
      expect(mail.body.raw_source).to match("This is a reminder that the deadline for submitting your local assessment reports is on #{ deadline }")
    end
  end
end
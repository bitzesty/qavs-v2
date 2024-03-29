require "rails_helper"

describe LieutenantsMailers::LocalAssessmentNotificationMailer do
  let(:county) { create :ceremonial_county }
  let(:lieutenant) { create :lieutenant, ceremonial_county: county }
  let(:form_answer) { create :form_answer, ceremonial_county: county }

  let(:mail) {
    LieutenantsMailers::LocalAssessmentNotificationMailer.notify(
      lieutenant.id
    )
  }
  let(:subject) {
    "Nominations are ready for you to assess"
  }

  describe "#notify" do
    it "renders the headers" do
      expect(subject).to eq subject
      expect(mail.to).to eq([lieutenant.email])
      expect(mail.from).to eq(["no-reply@kavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match("The KAVS nominations for #{ AwardYear.current.year } are now available to assess.")
    end
  end
end

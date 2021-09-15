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

  describe "#notify" do
    it "renders the headers" do
      expect(mail.to).to eq([lieutenant.email])
      expect(mail.from).to eq(["no-reply@qavs.dcms.gov.uk"])
    end

    it "renders the body" do
      expect(mail.body.raw_source).to match("The QAVS nominations for #{ AwardYear.current.year } are now available to assess.")
    end
  end
end

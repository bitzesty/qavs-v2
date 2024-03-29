require "rails_helper"

describe FormAnswerDecorator do
  DOCUMENT_FIELDS = {
    nominee_organisation: "organization_address_name",
    nominee_position: "nominee_position",
    nominee_building: "nominee_personal_address_building",
    nominee_street: "nominee_personal_address_street",
    nominee_city: "nominee_personal_address_city",
    nominee_county: "nominee_personal_address_county",
    nominee_postcode: "nominee_personal_address_postcode",
    nominee_telephone: "nominee_phone",
    nominee_email: "nominee_email",
    nominee_region: "nominee_personal_address_region",
    nominator_building: "personal_address_building",
    nominator_street: "personal_address_street",
    nominator_city: "personal_address_city",
    nominator_county: "personal_address_county",
    nominator_postcode: "personal_address_postcode",
    nominator_telephone: "personal_phone",
    nominator_email: "personal_email",
    registration_number: "registration_number",
    website_url: "website_url",
    head_of_business_title: "head_of_business_title",
    head_of_business_honours: "head_of_business_honours",
    head_job_title: "head_job_title",
    head_email: "head_email",
    applying_for: "applying_for",
    parent_company: "parent_company",
    parent_company_country: "parent_company_country",
    parent_ultimate_control: "parent_ultimate_control",
    ultimate_control_company: "ultimate_control_company",
    ultimate_control_company_country: "ultimate_control_company_country",
    organisation_type: "organisation_type"
  }

  let(:user) { build_stubbed(:user, first_name: "John", last_name: "Doe") }

  describe "#average_growth_for" do
    subject { described_class.new form_answer }
    let!(:form_answer) { build(:form_answer, document: { sic_code: sic_code.code }) }
    let(:year) { 1 }

    context "sic code present" do
      let(:sic_code) { SicCode.first }
      it "returns average growth for specific year" do
        expect(subject.average_growth_for(year)).to eq(sic_code.by_year(year))
      end
    end

    context "sic code not present" do
      let(:sic_code) { double(code: nil) }
      it "returns nil" do
        expect(subject.average_growth_for(year)).to be_nil
      end
    end
  end

  describe "#last_state_updated_by" do
    it "Returns the person and time of who made the last transition" do

      Timecop.freeze(DateTime.new(Date.current.year, 2, 6, 8, 30)) do
        form_answer = create(:form_answer).decorate
        form_answer.state_machine.submit(form_answer.user)
        expect(form_answer.last_state_updated_by).to eq("Updated by John Doe -  6 Feb #{Date.current.year} at 8:30am")
      end
    end
  end

  describe "#feedback_updated_by" do
    it "Returns the person and time of who made the feedback" do
      Timecop.freeze(DateTime.new(Date.current.year, 2, 6, 8, 30)) do
        form_answer = create(:feedback, authorable: user).form_answer.decorate
        expect(form_answer.feedback_updated_by).to eq("Updated by: John Doe -  6 Feb #{Date.current.year} at 8:30am")
      end
    end
  end

  describe "#dashboard_status" do
    it "returns fill progress when application is not submitted" do
     form_answer = create(:form_answer, state: "application_in_progress", document: { sic_code:  SicCode.first.code })
      expect(described_class.new(form_answer).dashboard_status).to eq("Nomination in progress...0%")
    end

    it "returns application state after submission" do
      form_answer = create(:form_answer, :submitted, state: "not_recommended")
      expect(described_class.new(form_answer).dashboard_status).to eq("National assessment - not recommended")

      form_answer.update_column(:state, "not_awarded")
      expect(described_class.new(form_answer).dashboard_status).to eq("Not awarded")

      form_answer.update_column(:state, "disqualified")
      expect(described_class.new(form_answer).dashboard_status).to eq("Disqualified - No Verification of Commercial Figures")
    end
  end

  describe "#application_background" do
    it "returns the trade_goods_briefly value" do
      document = {mobility_desc_short: "Mobility"}
      form = build(:form_answer, document: document)

      decorated_app = described_class.new(form)

      expect(decorated_app.application_background).to eq("Mobility")
    end
  end

  DOCUMENT_FIELDS.keys.each do |field|
    describe "##{field}" do
      it "returns the document field with key #{DOCUMENT_FIELDS[field]}" do
        document = {DOCUMENT_FIELDS[field] => 'An expected value'}
        form = build(:form_answer, document: document)

        decorated_app = described_class.new(form)
        expect(decorated_app.send(field)).to eq(document[DOCUMENT_FIELDS[field]])
      end
    end
  end
end

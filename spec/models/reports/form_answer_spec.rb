require "rails_helper"

describe Reports::FormAnswer do
  describe '#call_method' do
    it 'should return missing method' do
      expect(Reports::FormAnswer.new(build(:form_answer)).call_method(:missing)).to eq 'missing method'
    end
  end

  describe 'user methods' do
    let(:user) do
      build(:user,
            company_address_first: "company_address_first",
            company_address_second: "company_address_second",
            company_city: "company_city",
            company_postcode: "company_postcode",
            phone_number: "phone_number",
            company_phone_number: "company_phone_number",
      )
    end
    let(:report) {Reports::FormAnswer.new(build(:form_answer, user: user))}

    it '#address_line1 should return address_line1' do
      expect(report.address_line1).to eq "company_address_first"
    end

    it '#address_line2 should return address_line2' do
      expect(report.address_line2).to eq "company_address_second"
    end

    it '#address_line3 should return address_line3' do
      expect(report.address_line3).to eq "company_city"
    end

    it '#postcode should return postcode' do
      expect(report.postcode).to eq "company_postcode"
    end

    it '#telephone1 should return telephone1' do
      expect(report.telephone1).to eq "phone_number"
    end

    it '#telephone2 should return telephone2' do
      expect(report.telephone2).to eq "company_phone_number"
    end
  end
end

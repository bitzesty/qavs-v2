require "rails_helper"

describe Reports::DataPickers::FormDocumentPicker do
  let(:dummy_class) do
    klass = Class.new do
      include Reports::DataPickers::FormDocumentPicker

      def obj;
      end
    end
  end

  describe "instance methods" do
    let(:custom_class) do
      klass = Class.new do
        include Reports::DataPickers::FormDocumentPicker

        def question_visible?(key)
        end

        def obj
        end
      end
    end
    let(:subject) {custom_class.new}

    context "business_region" do
      it 'should return correct doc' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_region" => 1 }))
        expect(subject.business_region).to eq 1
      end
    end

    context "principal_postcode" do
      it 'should return correct value' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_postcode" => 'a' }))
        expect(subject.principal_postcode).to eq 'A'
      end
    end
    context "principal_address1" do
      it 'should return correct value' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_building" => 1 }))
        expect(subject.principal_address1).to eq 1
      end
    end

    context "principal_address2" do
      it 'should return correct value' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_street" => 1 }))
        expect(subject.principal_address2).to eq 1
      end
    end

    context "principal_address3" do
      it 'should return correct value' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_city" => 1 }))
        expect(subject.principal_address3).to eq 1
      end
    end

    context "principal_county" do
      it 'should return correct value' do
        allow(subject).to receive(:question_visible?).and_return(true)
        allow(subject).to receive(:obj).and_return(double(document: { "organization_address_county" => 1 }))
        expect(subject.principal_county).to eq 1
      end
    end

    context "sub_category" do
      it 'should return sub category' do
        object = double(document: {})
        allow(object).to receive(:award_type).and_return(nil)
        allow(subject).to receive(:obj).and_return(object)
        expect(subject.sub_category).to eq("Outstanding achievement over 3 years")
      end
    end
  end
end

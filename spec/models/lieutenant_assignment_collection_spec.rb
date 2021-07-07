require "rails_helper"

describe LieutenantAssignmentCollection do
  subject { described_class.new(params) }
  let(:form_answer) { create(:form_answer) }
  let!(:ceremonial_county) { create(:ceremonial_county) }

  context "Single assignment" do
    let(:params) do
      {
        form_answer_ids: form_answer.id.to_s,
        ceremonial_county_id: ceremonial_county.id.to_s
      }
    end

    it "assigns the assessor" do
      subject.save
      expect(form_answer.reload.ceremonial_county).to eq(ceremonial_county)
    end
  end
end

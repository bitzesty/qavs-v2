require "rails_helper"

describe AssessorAssignmentsConstructor do
  describe "#assessments" do
    let(:sub_group) { "sub_group_1" }
    let!(:assessor_1) { create(:assessor, sub_group: sub_group) }
    let!(:assessor_2) { create(:assessor, sub_group: sub_group) }
    let!(:assessor_3) { create(:assessor, sub_group: sub_group) }
    let!(:admin) { create(:admin) }

    let!(:nomination) { create(:form_answer, sub_group: sub_group) }


    context "for admin user" do
      let(:assessments) { described_class.new(nomination, admin).assessments }

      it "builds all assessments if there're none" do
        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(false)
      end

      it "builds only missing assessments" do
        create(:assessor_assignment, assessor_id: assessor_2.id, form_answer: nomination)

        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(false)
        expect(assessments.detect { |a| a.assessor_id == assessor_2.id }).to be_persisted
      end


      it "only fetches existing assessments" do
        create(:assessor_assignment, assessor_id: assessor_1.id, form_answer: nomination)
        create(:assessor_assignment, assessor_id: assessor_2.id, form_answer: nomination)
        create(:assessor_assignment, assessor_id: assessor_3.id, form_answer: nomination)

        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(true)
      end
    end

    context "for assessor user" do
      let(:assessments) { described_class.new(nomination, assessor_2).assessments }

      it "builds all assessments if there're none" do
        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(false)

        expect(assessments.first.assessor).to eq(assessor_2)
      end

      it "builds only missing assessments" do
        create(:assessor_assignment, assessor_id: assessor_3.id, form_answer: nomination)

        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(false)
        expect(assessments.detect { |a| a.assessor_id == assessor_3.id }).to be_persisted

        expect(assessments.first.assessor).to eq(assessor_2)
      end


      it "only fetches existing assessments" do
        create(:assessor_assignment, assessor_id: assessor_1.id, form_answer: nomination)
        create(:assessor_assignment, assessor_id: assessor_2.id, form_answer: nomination)
        create(:assessor_assignment, assessor_id: assessor_3.id, form_answer: nomination)

        expect(assessments.count).to eq(3)
        expect(assessments.map(&:assessor_id)).to include(assessor_1.id, assessor_2.id, assessor_3.id)
        expect(assessments.all?(&:persisted?)).to eq(true)

        expect(assessments.first.assessor).to eq(assessor_2)
      end
    end
  end
end

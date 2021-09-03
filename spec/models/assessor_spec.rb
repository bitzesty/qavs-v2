# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assessor, type: :model do
  describe "#soft_delete!" do
    it 'should set deleted' do
      assessor = create(:assessor)
      assessor.soft_delete!
      expect(assessor.deleted.present?).to be_truthy
    end
  end

  pending "reports" do
    it 'CasesStatusReport should return csv' do
      year = create(:award_year)
      assessor =  create(:assessor, :regular_for_trade)
      allow_any_instance_of(Reports::CasesStatusReport).to receive(:as_csv) {"csv string"}
      expect(Reports::CasesStatusReport.new(year).build_for_lead(assessor)).to eq "csv string"
    end

    it 'AssessorsProgressReport should return csv' do
      year = create(:award_year)
      assessor =  create(:assessor, :regular_for_trade)
      target_csv = "\"Assessor ID\",\"Assessor Name\",\"Assessor Email\",\"Primary Assigned\",\"Primary Assessed\",\"Primary Case Summary\",\"Primary Feedback\",\"Secondary Assigned\",\"Secondary Assessed\",\"Total Assigned\",\"Total Assessed\"\n\"#{assessor.id}\",\"John Doe\",\"#{assessor.email}\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\"\n"
      expect(Reports::AssessorsProgressReport.new(year, "trade").build).to eq target_csv
    end

    it 'AssessorReport should trigger correctly' do
      year = create(:award_year)
      assessor =  create(:assessor, :regular_for_trade)

      expect(Reports::CasesStatusReport).to receive_message_chain(:new, :build_for_lead)
      Reports::AssessorReport.new("cases-status", year, assessor).as_csv

      expect(Reports::AssessorsProgressReport).to receive_message_chain(:new, :build)
      Reports::AssessorReport.new("assessors-progress", year, assessor, category: 'trade').as_csv

      expect{Reports::AssessorReport.new("assessors-progress", year, assessor, category: 'invalid').as_csv}.to raise_error(ArgumentError)
    end
  end

  context "devise mailers" do
    let(:user) { create(:assessor) }

    include_context "devise mailers instructions"
  end

  describe "#applications_scope" do
    it "returns assigned applications in correct states" do
      assessor = create(:assessor)
      fa1 = create(:form_answer, sub_group: assessor.sub_group)
      fa2 = create(:form_answer, :submitted, sub_group: assessor.sub_group)
      fa3 = create(:form_answer, :local_assessment_not_recommended, sub_group: assessor.sub_group)
      fa4 = create(:form_answer, :withdrawn, sub_group: assessor.sub_group)
      fa5 = create(:form_answer, :not_recommended, sub_group: assessor.sub_group)
      fa6 = create(:form_answer, :shortlisted, sub_group: assessor.sub_group)
      fa7 = create(:form_answer, :shortlisted, sub_group: "sub_group_10")
      fa8 = create(:form_answer, :local_assessment_recommended, sub_group: assessor.sub_group)

      scope = assessor.applications_scope(fa1.award_year).pluck(:id)

      expect(scope).not_to include(fa1.id, fa2.id, fa3.id, fa4.id, fa7.id)
      expect(scope).to include(fa5.id, fa6.id, fa8.id)
    end
  end
end

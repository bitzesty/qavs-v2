require "rails_helper"

describe Reports::AssessorDecisionsReport do
  context "with empty assessments" do
    let!(:assessor) { create(:assessor) }
    let!(:fa) { create(:form_answer, :shortlisted, sub_group: assessor.sub_group) }

    it "is rendering report with empty columns" do
      build(:assessor_assignment, assessor: assessor, form_answer: fa)
      scope = assessor.applications_scope(fa.award_year)
      csv_txt = Reports::AssessorDecisionsReport.new(scope, fa.award_year, assessor).build
      csv = CSV.parse(csv_txt, headers: true)

      expect(csv.length).to eq(1)

      AppraisalForm.struct(fa).each do |key, section|
        label = section[:label]

        if section[:type] == :rag
          expect(csv.first["#{label} evaluation"]).to eq("")
          expect(csv.first["#{label} comments"]).to eq("")
        else
          expect(csv.first["#{label}"]).to eq("")
          expect(csv.first["#{label} comments"]).to eq("")
        end
      end
    end
  end

  context "with assessor appraisal content" do
    let!(:assessor) { create(:assessor) }
    let!(:fa) { create(:form_answer, :shortlisted, sub_group: assessor.sub_group) }

    it "displays report data for current assessor" do
      aa = build(:assessor_assignment, assessor: assessor, form_answer: fa)

      AppraisalForm.struct(fa).each do |key, section|
        if section[:type] == :rag
          aa.public_send("#{key}_rate=", "average")
        else
          aa.public_send("#{key}_rate=", "recommended")
        end
        aa.public_send("#{key}_desc=", "#{key} desc")
      end
      aa.submitted_at = Time.current

      aa.save!

      scope = assessor.applications_scope(fa.award_year)
      csv_txt = Reports::AssessorDecisionsReport.new(scope, fa.award_year, assessor).build
      csv = CSV.parse(csv_txt, headers: true)

      AppraisalForm.struct(fa).each do |key, section|
        label = section[:label]

        desc_val = "#{key} desc"

        if section[:type] == :rag
          rate_val = "average"
          expect(csv.first["#{label} evaluation"]).to eq(rate_val)
          expect(csv.first["#{label} comments"]).to eq(desc_val)
        else
          rate_val = "recommended"

          expect(csv.first["#{label}"]).to eq(rate_val)
          expect(csv.first["#{label} comments"]).to eq(desc_val)
        end
      end
    end
  end
end

require "rails_helper"

describe Reports::NationalAssessmentsReport do
  context "empty assessments" do
    let!(:fa1) { create(:form_answer, :submitted) }
    let!(:fa2) { create(:form_answer) }

    it "is rendering national assessment report with empty columns" do
      csv_txt = Reports::NationalAssessmentsReport.new(FormAnswer.all, fa1.award_year).build

      csv = CSV.parse(csv_txt, headers: true)
      expect(csv.length).to eq(2)

      2.times do |csv_index|
        4.times do |i|
          expect(csv[csv_index]["Assessor #{i + 1} name"]).to eq("")

          AppraisalForm.struct(fa1).each do |key, section|
            label = section[:label]

            if section[:type] == :rag
              expect(csv[csv_index]["#{label} Evaluation #{i + 1}"]).to eq("")
              expect(csv[csv_index]["#{label} Notes #{i + 1}"]).to eq("")
            else
              expect(csv[csv_index]["#{label} Decision #{i + 1}"]).to eq("")
              expect(csv[csv_index]["#{label} Verdict Notes #{i + 1}"]).to eq("")
            end
          end
        end
      end
    end
  end

  context "with all 3-4 assessments" do
    let!(:fa1) { create(:form_answer, :local_assessment_recommended) }
    let!(:fa2) { create(:form_answer, :local_assessment_recommended) }
    let(:assessor1) { create(:assessor) }
    let(:assessor2) { create(:assessor) }
    let(:assessor3) { create(:assessor) }
    let(:assessor4) { create(:assessor) }
    let!(:assessors) { [assessor1, assessor2, assessor3, assessor4] }

    before do
      3.times do |i|
        aa = build(:assessor_assignment, assessor: assessors[i], form_answer: fa1)

        AppraisalForm.struct(fa1).each do |key, section|
          if section[:type] == :rag
            aa.public_send("#{key}_rate=", "average")
          else
            aa.public_send("#{key}_rate=", "recommended")
          end
          aa.public_send("#{key}_desc=", "#{key} desc #{i}")
        end
        aa.submitted_at = Time.current

        aa.save!
      end

      4.times do |i|
        aa = build(:assessor_assignment, assessor: assessors[i], form_answer: fa2)

        AppraisalForm.struct(fa2).each do |key, section|
          if section[:type] == :rag
            aa.public_send("#{key}_rate=", "average")
          else
            aa.public_send("#{key}_rate=", "recommended")
          end
          aa.public_send("#{key}_desc=", "#{key} desc #{i}")
        end
        aa.submitted_at = Time.current

        aa.save!
      end
    end

    it "is rendering national assessment report with empty columns" do
      csv_txt = Reports::NationalAssessmentsReport.new(FormAnswer.all.order(:created_at), fa1.award_year).build

      csv = CSV.parse(csv_txt, headers: true)
      expect(csv.length).to eq(2)

      2.times do |csv_index|
        4.times do |i|
          assessor = csv_index == 0 && i == 3 ? "" : assessors[i].full_name
          expect(csv[csv_index]["Assessor #{i + 1} name"]).to eq(assessor)
          AppraisalForm.struct(fa1).each do |key, section|
            label = section[:label]

            # last assessment of the first nomination is empty
            desc_val = csv_index == 0 && i == 3 ? "" : "#{key} desc #{i}"

            if section[:type] == :rag
              rate_val = csv_index == 0 && i == 3 ? "" : "average"
              expect(csv[csv_index]["#{label} Evaluation #{i + 1}"]).to eq(rate_val)
              expect(csv[csv_index]["#{label} Notes #{i + 1}"]).to eq(desc_val)
            else
              rate_val = csv_index == 0 && i == 3 ? "" : "recommended"

              expect(csv[csv_index]["#{label} Decision #{i + 1}"]).to eq(rate_val)
              expect(csv[csv_index]["#{label} Verdict Notes #{i + 1}"]).to eq(desc_val)
            end
          end
        end
      end
    end
  end
end

require "rails_helper"

describe Reports::CitationReport do
  describe "scope" do
    let!(:form_answer) { create(:form_answer, :awarded) }
    let!(:citation) { create(:citation, :submitted, form_answer: form_answer) }

    it "includes only this years form answers" do
      ay = create(:award_year, year: Date.current.year - 2)
      other_fa = create(:form_answer, :awarded, award_year: ay)
      create(:citation, :submitted, form_answer: other_fa)

      expect(Reports::CitationReport.new(form_answer.award_year).scope.count).to eq(1)
    end

    it "includes only winners" do
      create(:form_answer, :submitted)

      expect(Reports::CitationReport.new(form_answer.award_year).scope.count).to eq(1)
    end


    it "includes only submitted citations" do
      other_fa = create(:form_answer, :awarded)
      create(:citation, form_answer: other_fa)

      expect(Reports::CitationReport.new(form_answer.award_year).scope.count).to eq(1)
    end
  end
end

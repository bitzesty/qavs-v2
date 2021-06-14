require "rails_helper"

# checks if returns the csv without checking if data are correct

describe Reports::AdminReport do
  subject { described_class.new(id, AwardYear.current) }
  let(:form_answer) { FormAnswer.last }

  describe "#as_csv" do
    describe "registered users" do
      before { create_test_forms }

      let(:id) { "registered-users" }

      it "generates the CSV" do
        expect(subject.as_csv).to include("0111")
      end
    end

    describe "cases status" do
      let(:id) { "cases-status" }
      before { create_test_forms }

      it "generates the CSV" do
        expect(subject.as_csv).to include("QAVS")
      end
    end

    describe "entries report" do
      let(:id) { "entries-report" }
      before { create_test_forms }

      it "generates the CSV" do
        expect(subject.as_csv).to include("QAVS")
      end
    end
  end
end

def create_test_forms
  create(:form_answer, :submitted)
end

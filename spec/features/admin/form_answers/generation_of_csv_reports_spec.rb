# extend to check the data more strictly - after reviewing by Client
require "rails_helper"

describe "Admin generates the CSV reports" do
  let!(:user) { create(:user, :completed_profile) }

  let!(:fa1) { create(:form_answer, user: user, submitted_at: Time.current) }
  let!(:fa2) { create(:form_answer, user: user) }
  let!(:fa3) { create(:form_answer, user: user, state: "awarded") }
  let!(:fa4) { create(:form_answer, user: user) }

  let(:output) do
    csv = Reports::AdminReport.new(id, AwardYear.current).as_csv
    CSV.parse(csv)
  end

  describe "Registered users entry" do
    let(:id) { "registered-users" }
    it "produces proper output" do
      expect(output.size).to eq(FormAnswer.count + 1)
      expect(output[1][7]).to eq("Test Company")
      expect(output[1][8]).to eq("qavs")
    end
  end

  describe "Cases status" do
    let(:id) { "cases-status" }
    it "produces proper output" do
      expect(output.size).to eq(2)
      expect(output[1][7]).to eq("No")
      expect(output[1][-1]).to eq("Outstanding achievement over 3 years")
    end
  end

  describe "Entries report" do
    let(:id) { "entries-report" }
    it "produces proper output" do
      expect(output.size).to eq(FormAnswer.count + 1)
      expect(output[1][1]).to eq("QAVS")
      expect(output[1][9]).to eq("Director")
    end
  end

  describe "Press book list" do
    let(:id) { "press-book-list" }
    it "produces proper output" do
      expect(output.size).to eq(2)
      expect(output[1][-6]).to eq("example.com")
    end
  end
end

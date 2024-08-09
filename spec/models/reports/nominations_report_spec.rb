require 'rails_helper'
require 'csv'

RSpec.describe Reports::NominationsReport, type: :model do
  let!(:form_answer) { create(:form_answer) }
  let(:report) { Reports::NominationsReport.new(FormAnswer.all).build }
  let(:csv_content) { CSV.parse(report, headers: true) }

  context 'renders the report with data' do
    it "renders rows" do
      expect(csv_content.length).to eq(1)
    end

    it "renders the correct columns" do
      columns = Reports::NominationsReport::MAPPING
      expect(csv_content.headers.length).to eq(columns.length)

      columns.each do |column|
        expect(csv_content.headers).to include(column[:label])
      end
    end

    it 'renders the correct data' do
      columns = Reports::NominationsReport::MAPPING
      nomination = Reports::Nomination.new(form_answer)
      columns.each do |column|
        expect(csv_content[0][column[:label]]).to eq(nomination.call_method(column[:method]).to_s)
      end
    end

    it 'renders new lines' do
      test_answer = "Line one\nLine two\nLine three"
      form_answer.document[:group_activities] = test_answer
      form_answer.save
      expect(csv_content[0]["Please summarise the activities of the group"]).to eq(test_answer)
    end
  end
end

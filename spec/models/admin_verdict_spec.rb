require 'rails_helper'

RSpec.describe AdminVerdict, type: :model do
  before do
    create(:settings, :expired_submission_deadlines)
  end

  context "state transitions" do
    let!(:form_answer) { create(:form_answer, :local_assessment_recommended) }
    let(:verdict) { build(:admin_verdict, form_answer: form_answer) }

    it "performs appropriate state transitions" do
      AdminVerdict::VERDICTS.each do |v|
        verdict.outcome = v
        verdict.save!

        expect(form_answer.reload.state).to eq(v)
      end
    end
  end
end

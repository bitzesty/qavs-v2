require 'rails_helper'

describe "QaePdfForms::Awards2016::Qavs::Base" do
  let!(:award_year) { AwardYear.current }

  include_context "pdf file checks"

  let(:step1_question_answers) {
    {
      nominee_name: "Bitzesty"
    }
  }

  let(:form_answer) do
    fa = FactoryBot.build(:form_answer, :submitted, user: user)
    fa.document = fa.document.merge(step1_question_answers.merge(step2_question_answers))
    fa.save!

    fa
  end
end

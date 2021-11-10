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

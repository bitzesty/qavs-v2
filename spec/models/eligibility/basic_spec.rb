require 'rails_helper'

RSpec.describe Eligibility::Basic, type: :model do
  let(:account) { FactoryBot.create(:account) }

  context 'answers storage' do
    it 'saves and reads answers' do
      eligibility = Eligibility::Basic.new(account: account)
      eligibility.based_in_uk = '1'

      expect { eligibility.save }.to change {
        Eligibility::Basic.count
      }.by(1)

      eligibility = Eligibility::Basic.last

      expect(eligibility.account).to eq(account)
      expect(eligibility).to be_based_in_uk
    end
  end

  describe '#eligible?' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'is not eligible by default' do
      expect(eligibility).not_to be_eligible
    end

    it 'is not eligible in the middle of the survey' do
      eligibility.involved_with_group = false
      eligibility.current_step = :based_in_uk
      eligibility.national_organisation = false
      eligibility.based_in_uk = true

      expect(eligibility).to_not be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.involved_with_group = false
      eligibility.based_in_uk = true
      eligibility.are_majority_volunteers = true
      eligibility.benefits_animals_only = false
      eligibility.national_organisation = false
      eligibility.has_at_least_three_people = true
      eligibility.provide_grants = false
      eligibility.local_area = true
      eligibility.years_operating = 3
      eligibility.current_holder = "no"

      expect(eligibility).to be_eligible
    end

    it 'is not eligible when not all answers are correct' do
      eligibility.national_organisation = false
      eligibility.based_in_uk = true
      eligibility.benefits_animals_only = false
      eligibility.has_at_least_three_people = false

      expect(eligibility).not_to be_eligible
    end
  end

  describe "#save_as_eligible" do
    let(:eligibility) { build(:basic_eligibility, answers: {}) }

    it "saves and marks eligibilty as eligible" do
      eligibility.save_as_eligible!
      eligibility.reload
      expect(eligibility).to be_eligible
    end
  end

  describe '#questions' do
    let(:eligibility) { Eligibility::Basic.new(account: account) }

    it 'returns all questions for new eligibility' do
      expect(eligibility.questions).to eq([
        :involved_with_group,
        :based_in_uk,
        :years_operating,
        :has_at_least_three_people,
        :are_majority_volunteers,
        :national_organisation,
        :local_area,
        :provide_grants,
        :benefits_animals_only,
        :current_holder
      ])
    end
  end
end

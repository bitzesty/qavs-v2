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

    it 'is eligible in the middle of the survey' do
      eligibility.current_step = :based_in_uk
      eligibility.national_organisation = false
      eligibility.based_in_uk = true

      expect(eligibility).to be_eligible
    end

    it 'is eligible when all questions are answered correctly' do
      eligibility.national_organisation = false
      eligibility.based_in_uk = true
      eligibility.are_majority_volunteers = true
      eligibility.benefits_animals_only = false
      eligibility.has_at_least_three_people = true
      eligibility.years_operating = 3

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
    let(:eligibility) { Eligibility::Basic.new(account: account) }

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
        :based_in_uk,
        :has_at_least_three_people,
        :are_majority_volunteers,
        :national_organisation,
        :benefits_animals_only,
        :years_operating,
        :current_holder
      ])
    end
  end
end

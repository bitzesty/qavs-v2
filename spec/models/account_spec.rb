require "rails_helper"

describe Account do
  let!(:account) do
    create(:account)
  end
  let!(:user) do
    create(:user, account: account)
  end
  let!(:current_year) { AwardYear.where(year: Date.today.year + 1).first_or_create }
  let!(:previous_year) { AwardYear.where(year: current_year).first_or_create }

  describe "#other_submitted_applications" do
    it "returns submitted applications for this account, excluding the one passed as an argument" do
      included_fa_1 = create(:form_answer, :submitted, award_year: current_year, user: user)
      included_fa_2 = create(:form_answer, :submitted, award_year: current_year, user: user)
      excluded_fa_1 = create(:form_answer, :submitted, award_year: current_year, user: user)
      excluded_fa_2 = create(:form_answer, award_year: current_year, user: user)
      excluded_fa_3 = create(:form_answer, :submitted, award_year: current_year)

      expect(account.reload.other_submitted_applications(excluded_fa_1).pluck(:id)).to contain_exactly(included_fa_1.id, included_fa_2.id)
    end
  end
end

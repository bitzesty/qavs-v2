require "rails_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "award winners section" do
  let(:user) do
    create :user, :completed_profile
  end

  let(:old_award_year) do
    AwardYear.create!(year: 2020)
  end

  let(:current_award_year) do
    AwardYear.create!(year: 2021)
  end

  let!(:current_year_mock) do
    allow(AwardYear).to receive(:current)
                    .and_return(current_award_year)
  end

  let!(:current_form_answer) do
    create :form_answer,
           :awarded,
           user: user,
           award_year_id: current_award_year.id
  end

  let!(:old_form_answer) do
    create :form_answer,
           :awarded,
           user: user,
           award_year_id: old_award_year.id
  end

  before do
    login_as(user, scope: :user)
    visit award_winners_section_path
  end

  it "see current year's submissions" do
    expect(page).to have_content(
      "Queen's Awards for Enterprise 2021 Emblem"
    )
    expect_to_be_accessible
  end

  it "don't see other year's submissions" do
    expect(page).to_not have_content(
      "Queen's Awards for Enterprise 2020 Emblem"
    )
    expect_to_be_accessible
  end
end

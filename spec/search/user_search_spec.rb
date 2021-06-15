require 'rails_helper'

describe UserSearch do
  before do
    [
     %w[Harmony Pelham],
     %w[Noella Adan],
     %w[Margot Tito],
     %w[Curt Knickerbocker],
     %w[Lea Reimer],
     %w[Lea Tencher],
     %w[Catrice Berk]
    ].each do |(first_name, last_name)|
      create(:user, first_name: first_name, last_name: last_name)
    end
  end

  it 'sorts user by full name' do
    results = described_class.new(User.all).search(sort: 'full_name').results

    sorted_names = results.map { |user| "#{user.first_name} #{user.last_name}" }
    expected =
      [
       "Catrice Berk",
       "Curt Knickerbocker",
       "Harmony Pelham",
       "Lea Reimer",
       "Lea Tencher",
       "Margot Tito",
       "Noella Adan"
      ]
    expect(sorted_names).to eq(expected)
  end
end

FactoryBot.define do
  factory :ceremonial_county do
    sequence(:name) { |n| "County #{n}"}
  end
end

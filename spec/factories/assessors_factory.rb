FactoryBot.define do
  factory :assessor do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    sub_group { "sub_group_1" }
    confirmed_at { Time.zone.now }

    trait :lead_for_all do

    end

    trait :regular_for_all do
    end
  end
end

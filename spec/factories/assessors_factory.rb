FactoryBot.define do
  factory :assessor do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    confirmed_at { Time.zone.now }

    trait :lead_for_all do
      qavs_role { "lead" }
    end

    trait :regular_for_all do
      qavs_role { "regular" }
    end
  end
end

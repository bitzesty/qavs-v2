FactoryBot.define do
  factory :lieutenant do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    confirmed_at { Time.zone.now }
    role { "regular" }

    trait :advanced do
      role { "advanced" }
    end
  end
end

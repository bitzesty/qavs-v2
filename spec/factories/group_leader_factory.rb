FactoryBot.define do
  factory :group_leader do
    first_name { "John" }
    last_name { "Doe" }
    password { "my98ssdkjv9823kds=2" }
    email
    confirmed_at { Time.zone.now }
  end
end

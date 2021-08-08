FactoryBot.define do
  factory :citation do
    association :group_leader, factory: :group_leader
    group_name { "Bit Zesty"}
    body { "citation text body" }
  end
end

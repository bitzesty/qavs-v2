FactoryBot.define do
  factory :citation do
    association :group_leader, factory: :form_answer
    group_name { "Bit Zesty"}
    body { "citation text body" }
  end
end

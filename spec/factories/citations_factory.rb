FactoryBot.define do
  factory :citation do
    association :form_answer, factory: :form_answer
    group_name { "Bit Zesty"}
    body { "citation text body" }
  end
end

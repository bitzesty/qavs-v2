FactoryBot.define do
  factory :palace_invite do
    email { "MyString" }
    association :form_answer

    trait :submitted do
      submitted { true }
    end
  end
end

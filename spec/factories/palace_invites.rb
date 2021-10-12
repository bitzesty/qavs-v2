FactoryBot.define do
  factory :palace_invite do
    email { "MyString" }
    association :form_answer
    attendees_consent { '1' }

    trait :submitted do
      submitted { true }
    end
  end
end

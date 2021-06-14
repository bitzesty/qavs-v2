FactoryBot.define do
  factory :assessor_assignment do
    association :form_answer

    trait :qavs do
      form_answer { create(:form_answer) }
    end

    trait :submitted do
      submitted_at { DateTime.now - 1.minute }
    end
  end

  factory :assessor_assignment_moderated, class: AssessorAssignment do
    association :form_answer
    position { "moderated" }
  end
end

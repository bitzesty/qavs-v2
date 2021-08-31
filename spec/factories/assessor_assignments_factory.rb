FactoryBot.define do
  factory :assessor_assignment do
    association :form_answer

    trait :valid_for_submission do
      good_impact_rate { "average" }
      good_impact_desc { "desc" }
      volunteer_led_rate { "average" }
      volunteer_led_desc { "desc" }
      good_governance_rate { "average" }
      good_governance_desc { "desc" }
      exceptional_qualities_rate { "average" }
      exceptional_qualities_desc { "desc" }
      verdict_rate { "recommended" }
      verdict_desc { "verd. desc" }
    end

    trait :qavs do
      form_answer { create(:form_answer) }
    end

    trait :submitted do
      valid_for_submission
      submitted_at { DateTime.now - 1.minute }
    end
  end
end

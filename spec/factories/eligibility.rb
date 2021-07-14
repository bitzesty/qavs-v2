FactoryBot.define do
  factory :eligibility do
    association :account, factory: :account
    association :form_answer, factory: :form_answer

    trait :passed do
      passed { true }
    end

    trait :basic do
      type { "Eligibility::Basic" }
      current_step { :current_holder }
      answers { {
        kind: "application",
        based_in_uk: true,
        are_majority_volunteers: true,
        has_at_least_three_people: true,
        national_organisation: false,
        self_contained_enterprise: true,
        current_holder: "no"
      }}
    end


    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic]
  end
end

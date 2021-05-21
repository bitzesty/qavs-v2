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
        do_you_file_company_tax_returns: true,
        has_management_and_two_employees: true,
        organization_kind: "business",
        industry: "product_business",
        self_contained_enterprise: true,
        current_holder: "no"
      }}
    end


    factory :basic_eligibility, class: "Eligibility::Basic", traits: [:basic]
  end
end

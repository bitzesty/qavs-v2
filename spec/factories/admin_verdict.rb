FactoryBot.define do
  factory :admin_verdict do
    association :form_answer
    outcome { "shortlisted" }

    description { "desc" }
  end
end

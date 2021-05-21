FactoryBot.define do
  factory :form_answer do
    association :user, factory: [:user, :agreed_to_be_contacted]
    award_year_id { AwardYear.current.id }

    document do
      FormAnswer::DocumentParser.parse_json_document(
        JSON.parse(
          File.read(Rails.root.join("spec/fixtures/form_answer_qavs.json"))
        )
      )
    end

    trait :submitted do
      submitted_at { Time.current }

      state { "submitted" }
    end

    trait :awarded do
      submitted_at { Time.current }
      state { "awarded" }
    end

    trait :recommended do
      submitted_at { Time.current }
      state { "recommended" }
    end

    trait :withdrawn do
      state { "withdrawn" }
    end

    trait :not_recommended do
      submitted_at { Time.current }
      state { "not_recommended" }
    end

    trait :not_awarded do
      submitted_at { Time.current }
      state { "not_awarded" }
    end

    trait :reserved do
      submitted_at { Time.current }
      state { "reserved" }
    end

    trait :with_audit_certificate do
      document do
        FormAnswer::DocumentParser.parse_json_document(
          JSON.parse(
            File.read(Rails.root.join("spec/fixtures/form_answer_development.json"))
          )
        )
      end
      audit_certificate
      state { "submitted" }
      submitted_at { Time.current }
    end
  end
end

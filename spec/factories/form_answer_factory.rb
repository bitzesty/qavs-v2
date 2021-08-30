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

    trait :local_assessment_recommended do
      submitted_at { Time.current }

      state { "local_assessment_recommended" }
    end

    trait :local_assessment_not_recommended do
      submitted_at { Time.current }

      state { "local_assessment_not_recommended" }
    end

    trait :admin_eligible do
      submitted_at { Time.current }

      state { "admin_eligible" }
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

    trait :with_support_letters do
      after(:create) do |form|
        ids = []
        2.times { ids << create(:support_letter_attachment, form_answer: form, user: form.user).id }

        doc = form.document
        doc["supporter_letters_list"] = [
          {
            "support_letter_id" => ids.first.to_s,
            "first_name" => "First",
            "last_name" => "Supporter",
            "relationship_to_nominee" => "Supporter",
            "letter_of_support" =>  ids.first.to_s
          },
          {
            "support_letter_id" => ids.last.to_s,
            "first_name" => "Second",
            "last_name" => "Supporter",
            "relationship_to_nominee" => "Supporter",
            "letter_of_support" =>  ids.last.to_s
          }
        ]
        form.document = doc
        form.save!
      end

    end
  end
end

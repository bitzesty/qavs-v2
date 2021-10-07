FactoryBot.define do
  factory :palace_invite_form do
    association :invite, factory: :palace_invite
    attendees_consent { "1" }
  end
end

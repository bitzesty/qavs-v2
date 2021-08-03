class PalaceAttendee < ApplicationRecord
  extend Enumerize
  
  belongs_to :palace_invite

  validates :palace_invite,
            :title,
            :first_name,
            :last_name,
            :address_1,
            :postcode,
            :relationship,
            :disabled_access,
            :preferred_date,
            :alternative_date,
            presence: true

  enumerize :preferred_date, in: %w(
    any
    buck_1
    buck_2
    buck_3
    holy
  )

  enumerize :alternative_date, in: %w(
    any
    buck_1
    buck_2
    buck_3
    holy
    none
  )
end

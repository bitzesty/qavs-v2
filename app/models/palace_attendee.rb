class PalaceAttendee < ApplicationRecord
  extend Enumerize

  belongs_to :palace_invite

  validates :palace_invite,
            :first_name,
            :last_name,
            :address_1,
            :postcode,
            :relationship,
            :preferred_date,
            :alternative_date,
            presence: true
  validates_inclusion_of :disabled_access, in: [true, false]

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

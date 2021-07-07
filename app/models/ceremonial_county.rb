class CeremonialCounty < ApplicationRecord
  has_many :lieutenants, dependent: :nullify

  validates :name, presence: true
end

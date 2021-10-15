class CeremonialCounty < ApplicationRecord
  has_many :lieutenants, dependent: :nullify
  has_many :form_answers, dependent: :nullify

  validates :name, presence: true

  scope :ordered, -> { order(:country, :name) }
end

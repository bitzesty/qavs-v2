class CeremonialCounty < ApplicationRecord
  has_many :lieutenants, dependent: :nullify
  has_many :form_answers, dependent: :nullify

  validates :name, presence: true

  COUNTY_MAPPINGS = {
     
  }

end

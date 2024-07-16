class SupportLetter < ApplicationRecord
  begin :associations
    belongs_to :form_answer
    belongs_to :user

    has_one :support_letter_attachment, autosave: true, dependent: :destroy
  end

  begin :validations
    validates :first_name,
              :last_name,
              :user,
              :form_answer,
              :relationship_to_nominee, presence: true
    validates :attachment, presence: true, if: proc { manual? && !support_letter_attachment }
    validates :body, presence: true, unless: :manual?
    validates :support_letter_attachment, presence: true, if: proc { manual? }
  end

  begin :scopes
    scope :manual, -> { where(manual: true) }
    scope :not_manual, -> { where(manual: false) }
  end

  accepts_nested_attributes_for :support_letter_attachment

  attr_accessor :attachment

  def full_name
    [first_name, last_name].join(" ")
  end
end

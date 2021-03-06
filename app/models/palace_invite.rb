class PalaceInvite < ApplicationRecord
  attr_accessor :attendees_consent

  belongs_to :form_answer

  has_many :palace_attendees, dependent: :destroy, autosave: true

  validates :form_answer_id, presence: true,
                             uniqueness: true

  validates :attendees_consent, acceptance: { allow_nil: false, accept: "1" }, on: :update

  before_create :set_token

  def prebuild_if_necessary
    attendees = palace_attendees
    records = attendees.select { |a| !a.new_record? }
    unless records.size == attendees_limit
      to_build = attendees_limit - records.size
      to_build.times do
        palace_attendees.build
      end
    end
    self
  end

  def submit!
    self.submitted = true
    save
  end

  def attendees_limit
    2
  end

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64(24)
  end
end

class Admin < ApplicationRecord
  include PgSearch::Model
  include AutosaveTokenGeneration
  include SoftDelete

  devise :authy_authenticatable, :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable, :timeoutable, :session_limitable

  include PasswordSkippable

  validates :first_name, :last_name, presence: true

  has_many :form_answer_attachments, as: :attachable
  has_many :protected_files, as: :entity, dependent: :destroy

  pg_search_scope :basic_search,
                  against: [
                    :first_name,
                    :last_name,
                    :email
                  ],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }
  def lead?(*)
    true
  end

  def primary?(*)
    true
  end

  def secondary?(*)
    true
  end

  def lead_or_assigned?(*)
    true
  end

  def active_for_authentication?
    super && !deleted?
  end

  def timeout_in
    20.minutes
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  private

  def min_password_score
    3
  end

  # Do not raise an error if already confirmed.
  def pending_any_confirmation
    if (!confirmed? || pending_reconfirmation?)
      yield
    end
  end
end

class GroupLeader < ApplicationRecord
  include SoftDelete
  include PgSearch::Model

  devise :database_authenticatable,
         :recoverable, :trackable, :validatable,
         :zxcvbnable, :lockable, :timeoutable

  include PasswordSkippable


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

  belongs_to :form_answer, optional: true

  has_many :protected_files, as: :entity, dependent: :destroy

  scope :by_email, -> { order(:email) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  validates :first_name, :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def password_required?
    return false if skip_password_validation
    super
  end

  def timeout_in
    22.hours
  end

  def self.reset_password_within
    4.weeks
  end

  private

  # Do not raise an error if already confirmed.
  def pending_any_confirmation
    if (!confirmed? || pending_reconfirmation?)
      yield
    end
  end
end

class Lieutenant < ApplicationRecord
  extend Enumerize
  include PgSearch::Model
  include SoftDelete

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :zxcvbnable, :timeoutable,
         :session_limitable, :trackable

  include PasswordSkippable

  belongs_to :ceremonial_county

  has_many :protected_files, as: :entity, dependent: :destroy

  validates :first_name, :last_name, :role, :ceremonial_county, presence: true

  enumerize :role, in: %w(regular advanced)

  scope :from_county, -> (county) { where(ceremonial_county_id: county.id) }

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

  def assigned_nominations
    nominations_scope
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def nominations_scope(award_year = nil)
    if award_year
      award_year.form_answers
    else
      FormAnswer.all
    end.where(ceremonial_county_id: ceremonial_county_id)
  end

  def password_required?
    return false if skip_password_validation
    super
  end

  def timeout_in
    20.minutes
  end

  private
  # Do not raise an error if already confirmed.
  def pending_any_confirmation
    if (!confirmed? || pending_reconfirmation?)
      yield
    end
  end
end

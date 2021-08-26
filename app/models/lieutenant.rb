class Lieutenant < ApplicationRecord
  extend Enumerize
  include PgSearch::Model
  include SoftDelete

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :zxcvbnable, :timeoutable,
         :session_limitable, :trackable

  include PasswordSkippable

  belongs_to :ceremonial_county

  validates :first_name, :last_name, :role, :ceremonial_county, presence: true

  enumerize :role, in: %w(regular advanced)

  default_scope { where(deleted: false) }

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
end

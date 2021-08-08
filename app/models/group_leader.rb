class GroupLeader < ApplicationRecord
  include SoftDelete
  include PgSearch::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
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

  has_many :form_answers
  has_one :citation, dependent: :destroy

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
end

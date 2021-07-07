class Lieutenant < ApplicationRecord
  extend Enumerize
  include PgSearch::Model

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :zxcvbnable, :timeoutable,
         :session_limitable


  validates :first_name, :last_name, presence: true

  enumerize :role, in: %w(regular advanced)

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

  def soft_delete!
    update_column(:deleted, true)
  end

  def assigned_nominations
    nominations_scope
  end

  # Dummy method, will be changed later
  def nominations_scope(award_year = nil)
    if award_year
      award_year.form_answers
    else
      FormAnswer.all
    end
  end
end

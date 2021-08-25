class Assessor < ApplicationRecord
  include PgSearch::Model
  include AutosaveTokenGeneration
  include SoftDelete
  extend Enumerize

  devise :database_authenticatable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable, :timeoutable, :session_limitable

  include PasswordSkippable

  SUBGROUPS = (1..10).map { |i| "sub_group_#{i}".freeze }

  enumerize :sub_group, in: SUBGROUPS

  validates :first_name, :last_name, :sub_group, presence: true
  has_many :form_answer_attachments, as: :attachable
  has_many :assessor_assignments

  has_many :form_answers,
           through: :assessor_assignments

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

  scope :by_email, -> { order(:email) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def active_for_authentication?
    super && !deleted?
  end

  def applications_scope(award_year = nil)
    join = "LEFT OUTER JOIN assessor_assignments ON
    assessor_assignments.form_answer_id = form_answers.id"

    scope = if award_year
      award_year.form_answers
    else
      FormAnswer
    end

    out = scope.joins(join)
    out.where("
      (assessor_assignments.position in (?) AND assessor_assignments.assessor_id = ?)
      AND form_answers.state NOT IN (?)
    ", [0, 1], id, "withdrawn")
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def assigned?(form_answer)
    form_answer.assessors.include?(self)
  end

  def timeout_in
    30.minutes
  end
end

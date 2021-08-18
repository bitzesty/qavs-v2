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
           foreign_key: :sub_group,
           primary_key: :sub_group

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

  default_scope { where(deleted: false) }

  scope :by_email, -> { order(:email) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def active_for_authentication?
    super && !deleted?
  end

  def applications_scope(award_year)
    award_year.form_answers.where(state: FormAnswerStateMachine::ASSESSOR_VISIBLE_STATES, sub_group: sub_group)
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

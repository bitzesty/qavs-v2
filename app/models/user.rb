class User < ApplicationRecord
  include PgSearch::Model
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable,
         :zxcvbnable, :lockable, :timeoutable, :session_limitable

  include PasswordSkippable

  attr_accessor :agreed_with_privacy_policy
  attr_accessor :current_password

  validates :agreed_with_privacy_policy, acceptance: { allow_nil: false, accept: '1' }, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true

  # First step validations
  validates :title, presence: true, if: -> { first_step? }
  validates :job_title, presence: true, if: -> { first_step? }
  validates :phone_number, presence: true, if: -> { first_step? }

  validates :phone_number, length: {
    minimum: 7,
    maximum: 20,
    message: "This is not a valid telephone number"
  }, if: -> { first_step? }

  validates :company_phone_number, length: {
    minimum: 7,
    maximum: 20,
    message: "This is not a valid telephone number"
  }, allow_blank: true, if: -> { second_step? }

  validates_with AdvancedEmailValidator, unless: -> { Rails.env.test? || Rails.env.development? }

  begin :associations
    has_many :form_answers
    has_many :feedbacks, through: :form_answers,
                         class_name: "Feedback",
                         source: :feedback
    has_one :owned_account, foreign_key: :owner_id, class_name: 'Account'

    belongs_to :account
    has_many :form_answer_attachments, as: :attachable
    has_many :support_letter_attachments, dependent: :destroy
    
    has_many :protected_files, as: :entity, dependent: :destroy
  end

  begin :scopes
    scope :not_including, -> (user) {
      where.not(id: user.id)
    }
    scope :by_email, -> { order(:email) }
    scope :qae_opt_in_group, -> { where(subscribed_to_emails: true) }
    scope :bit_opt_in, -> { where(agree_being_contacted_by_department_of_business: true) }
    scope :confirmed, -> {
      where("confirmed_at IS NOT NULL")
    }
    scope :by_query_part, -> (email) {
      where("email ilike ? OR first_name ilike ? OR last_name ilike ?",
            "%#{email}%", "%#{email}%", "%#{email}%")
    }
    scope :not_in_ids, -> (ids) {
      where.not(id: ids)
    }
    scope :allowed_to_get_award_open_notification, -> (award_type) {
      where("notification_when_#{award_type}_award_open" => true)
    }
  end

  before_validation :create_account, on: :create
  around_save :update_user_full_name

  enumerize :prefered_method_of_contact, in: %w(phone email)
  enumerize :qae_info_source, in: %w(
    govuk
    competitor
    business_event
    national_press
    business_press
    online
    local_trade_body
    national_trade_body
    mail_from_qae word_of_mouth other)

  begin :searching
    pg_search_scope :basic_search,
                    against: [
                      :email,
                      :first_name,
                      :last_name,
                      :company_name
                    ],
                    using: {
                      tsearch: {
                        prefix: true
                      }
                    }
    # TODO: take into consideration forcing NULL for all attributes.
    nilify_blanks only: [
      :title,
      :first_name,
      :last_name,
      :company_name
    ]
  end

  def set_step (step)
    @current_step = step
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def reset_password_period_valid?
    release_date = Date.new(2015, 4, 21)
    if imported? && reset_password_sent_at.present? && reset_password_sent_at.to_date == release_date
      true
    else
      super
    end
  end

  def can_be_added_to_collaborators_to_another_account?
    account.blank? || (
      account.present? &&
      form_answers.blank? &&
      account.form_answers.blank?
    )
  end

  def new_member?
    created_at > 3.days.ago
  end

  def timeout_in
    22.hours
  end

  def registration_in_progress?
    !completed_registration
  end

  private

  def first_step?
    @current_step && @current_step >= 1
  end

  def second_step?
    @current_step && @current_step >= 2
  end

  def create_account
    self.account = Account.create(owner: self) unless account
  end

  def update_user_full_name
    full_name_changed = first_name_changed? || last_name_changed?
    yield
    form_answers.each { |f| f.update(user_full_name: full_name) } if full_name_changed
  end

  # Do not raise an error if already confirmed.
  def pending_any_confirmation
    if (!confirmed? || pending_reconfirmation?)
      yield
    end
  end
end

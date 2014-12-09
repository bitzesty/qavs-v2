require 'qae_2014_forms'

class FormAnswer < ActiveRecord::Base
  POSSIBLE_AWARDS = [
    "trade", # International Trade Award
    "innovation", # Innovation Award
    "development", # Sustainable Development Award
    "promotion" # Enterprise promotion Award
  ]

  CURRENT_AWARD_YEAR = '14'

  begin :associations
    belongs_to :user
    belongs_to :account
  end

  begin :validations
    validates :user, presence: true
    validates :award_type, presence: true,
                           inclusion: {
                             in: POSSIBLE_AWARDS
                           }
    validates_uniqueness_of :urn, allow_nil: true, allow_blank: true
  end

  begin :scopes
    scope :for_award_type, -> (award_type) { where award_type: award_type }
    scope :for_user, -> (user) { where user: user }
    scope :for_account, -> (account) { where account: account }
  end

  before_create :set_account
  before_save :set_urn

  store_accessor :document
  store_accessor :eligibility
  store_accessor :basic_eligibility

  attr_accessor :submitted

  def award_form
    case award_type
    when "trade"
      QAE2014Forms.trade
    when "innovation"
      QAE2014Forms.innovation
    when "development"
      QAE2014Forms.development
    when "promotion"
      QAE2014Forms.promotion
    end
  end

  def eligibility_class
    "Eligibility::#{award_type.capitalize}".constantize
  end

  def load_eligibility(user)
    eligibility_class.new(eligibility) || user.public_send("#{award_type}_eligibility") || user.public_send("build_#{award_type}_eligibility")
  end

  def load_basic_eligibility(user)
    Eligibility::Basic.new(basic_eligibility) || user.basic_eligibility || user.build_basic_eligibility
  end

  def eligible?
    eligibility_class.new(eligibility).eligible? && Eligibility::Basic.new(basic_eligibility).eligible?
  end

  private

  def set_urn
    return if urn
    return unless submitted
    return unless award_type

    next_seq = self.class.connection.select_value("SELECT nextval(#{ActiveRecord::Base.sanitize("urn_seq_#{award_type}")})")

    self.urn = "QA#{sprintf("%.4d", next_seq)}/#{CURRENT_AWARD_YEAR}#{award_type[0].capitalize}"
  end

  def set_account
    self.account = user.account
  end
end

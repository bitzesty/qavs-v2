class AwardYear < ApplicationRecord
  validates :year, presence: true

  has_many :form_answers
  has_many :assessor_assignments
  has_many :feedbacks
  has_one :settings, inverse_of: :award_year, autosave: true

  after_create :create_settings

  AVAILABLE_YEARS = [2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027]

  DEFAULT_FINANCIAL_DEADLINE_DAY = 17
  DEFAULT_FINANCIAL_DEADLINE_MONTH = 9

  scope :past, -> {
    where(year: past_years)
  }

  CURRENT_YEAR_AWARDS = [
    "qavs"
  ]

  def current?
    self.year == self.class.current.year
  end

  def form_data_generation_can_be_started?
    Settings.after_current_submission_deadline? &&
    form_data_hard_copies_state.nil?
  end

  def check_hard_copy_pdf_generation_status!(type)
    scope = send("hard_copy_#{type}_scope")

    condition_rule = if type == "form_data"
      scope.count == scope.hard_copy_generated(type).count
    else
      scope.count.count == scope.hard_copy_generated(type).count.count
    end

    if condition_rule
      update_column("#{type}_hard_copies_state", "completed")
    else
      false
    end
  end

  def hard_copy_form_data_scope
    form_answers.submitted
  end

  # +1 here is to match URN number of assosiated forms
  def self.mock_current_year?
    Rails.env.test?
  end

  def self.current
    Rails.cache.fetch "current_award_year", expires_in: 1.minute do
      return where(year: DateTime.now.year + 1).first_or_create if mock_current_year?
      now = DateTime.now
      deadline = AwardYear.where(year: now.year + 1)
                          .first_or_create
                          .settings.deadlines
                          .award_year_switch
                          .try(:trigger_at)

      deadline ||= Date.new(now.year, 4, 21)
      if now >= deadline.to_datetime
        y = now.year + 1
      else
        y = now.year
      end

      where(year: y).first_or_create
    end
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def self.closed
    for_year(Date.current.year).first_or_create
  end

  def self.for_year(year)
    where(year: year)
  end

  def user_creation_range
    # Assumes that:
    # 1. User is created in the same calendar year as the submission period is open
    # 2. Submissions period can't cover 2 calendar years
    (DateTime.new(year - 1)..DateTime.new(year - 1, 12).end_of_month)
  end

  def self.award_holder_range
    "#{AwardYear.current.year - 5}-#{AwardYear.current.year - 1}"
  end

  def self.admin_switch
    output = {}
    year0 = 2022
    (year0..(current.year + 3)).each do |year|
      output[year] = "#{year - 1} - #{year}"
    end
    output
  end

  def settings
    @settings ||= Settings.where(award_year: self).first_or_create
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  def self.past_years
    years = AVAILABLE_YEARS.slice_before(current.year).to_a
    years[0] if years.count > 1
  end

  class << self
    # Buckingham Palace Reception date
    # is usually 14th July
    # so new award year would be already started
    # that's why we are pulling this date from current year (not current award year)

    def current_year_deadline(title)
      res = closed.settings
                  .deadlines
                  .where(kind: title)
                  .first

      if ::ServerEnvironment.local_or_dev_or_staging_server? && res.try(:trigger_at).blank?
        #
        # In testing purposes: on dev, local or staging we should be able to have
        # Buckingham Palace Reception date even if award year is not closed yet.
        #
        res = current.settings
                     .deadlines
                     .where(kind: title)
                     .first
      end

      res
    end

    def buckingham_palace_reception_deadline
      current_year_deadline("buckingham_palace_attendees_invite")
    end

    def buckingham_palace_reception_date
      buckingham_palace_reception_deadline.trigger_at
    end

    def buckingham_palace_reception_attendee_information_due_by
      current_year_deadline(
        "buckingham_palace_reception_attendee_information_due_by"
      ).trigger_at
    end

    def start_trading_since(years_number=3)
      if AwardYear.current.year < 2019
        Date.new(AwardYear.current.year - 1 - years_number, 9, 3).strftime("%d/%m/%Y")
      else
        day = DEFAULT_FINANCIAL_DEADLINE_DAY
        month = DEFAULT_FINANCIAL_DEADLINE_MONTH

        if (deadline = Settings.current_submission_deadline) && deadline.trigger_at
          day = deadline.trigger_at.day
          month = deadline.trigger_at.month
        end

        Date.new(AwardYear.current.year - 1 - years_number, month, day).strftime("%d/%m/%Y")
      end
    end
  end
end

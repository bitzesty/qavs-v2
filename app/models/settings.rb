class Settings < ApplicationRecord
  self.table_name = "settings"

  has_many :deadlines, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  belongs_to :award_year, inverse_of: :settings

  validates :award_year, presence: true

  after_create :create_deadlines

  class << self
    def current
      Rails.cache.fetch("current_settings", expires_in: 1.minute) do
        AwardYear.current.settings
      end
    end

    def current_award_year_switch_date
      Rails.cache.fetch("award_year_switch_deadline", expires_in: 1.minute) do
        current.deadlines.award_year_switch
      end
    end

    def current_submission_start_deadline
      current_award_year_switch_date
    end

    def current_submission_deadline
      Rails.cache.fetch("submission_end_deadline", expires_in: 1.minute) do
        current.deadlines.submission_end.first
      end
    end

    def current_local_assessment_submission_deadline
      Rails.cache.fetch("local_assessment_submission_end", expires_in: 1.minute) do
        current.deadlines.local_assessment_submission_end.first
      end
    end

    def current_palace_reception_attendee_information_deadline
      Rails.cache.fetch("buckingham_palace_reception_attendee_information_due_by", expires_in: 1.minute) do
        current.deadlines.buckingham_palace_reception_attendee_information_due_by
      end
    end

    def winner_notification_date
      Rails.cache.fetch("winners_notification", expires_in: 1.minute) do
        current.winners_email_notification.try(:trigger_at).presence
      end
    end

    def after_current_submission_deadline_start?
      current_submission_start_deadline.try(:passed?)
    end

    def after_current_submission_deadline?
      deadline = current_submission_deadline.trigger_at
      DateTime.now >= deadline if deadline.present?
    end

    def winners_stage?
      deadline = Rails.cache.fetch("winners_notification_notification", expires_in: 1.minute) do
        current.winners_email_notification
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def unsuccessful_stage?
      deadline = Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
        current.email_notifications.where(kind: "unsuccessful_notification").first
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def buckingham_palace_invites_stage?(settings = nil)
      settings = current if settings.blank?

      deadline = Rails.cache.fetch("buckingham_palace_invite", expires_in: 1.minute) do
        settings.email_notifications.where(kind: "buckingham_palace_invite").first
      end

      DateTime.now >= deadline.trigger_at if deadline.present?
    end

    def current_award_year_switched?
      award_year_switch_deadline = current_award_year_switch_date.try(:trigger_at)

      award_year_switch_deadline.present? &&
      award_year_switch_deadline < Time.zone.now && (
        after_current_submission_deadline_start?
      )
    end

    def not_awarded_deadline
      Rails.cache.fetch("unsuccessful_notification_notification", expires_in: 1.minute) do
        current.email_notifications.not_awarded.first.try(:trigger_at)
      end
    end

    def submission_deadline_title
      formatted_datetime = current_submission_deadline.strftime("%d %b %Y at %H:%M%P")
      "Submission deadline: #{formatted_datetime}"
    end
  end

  def winners_email_notification
    email_notifications.where(kind: "winners_notification").first
  end

  private

  def create_deadlines
    Deadline.enumerized_attributes[:kind].values.each do |kind|
      deadlines.where(kind: kind).first_or_create
    end
  end
end

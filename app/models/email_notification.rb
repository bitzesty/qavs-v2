class EmailNotification < ApplicationRecord
  extend Enumerize
  include FormattedTime::DateTimeFor

  NOTIFICATION_KINDS = [
                         :award_year_open_notifier,
                         :reminder_to_submit,
                         :group_leader_notification,
                         :local_assessment_notification,
                         :local_assessment_reminder,
                         :winners_notification,
                         :unsuccessful_notification,
                         :unsuccessful_ep_notification,
                         :shortlisted_notifier,
                         :not_shortlisted_notifier,
                         :winners_head_of_organisation_notification,
                         :unsuccessful_group_leaders_notification,
                         :buckingham_palace_invite
                       ]

  date_time_for :trigger_at

  belongs_to :settings

  enumerize :kind, in: NOTIFICATION_KINDS

  validates :kind, :trigger_at, presence: true

  after_save :clear_cache
  after_destroy :clear_cache

  scope :current, -> { where("trigger_at < ?", Time.now.utc).where("sent = 'f' OR sent IS NULL") }

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end

  def self.not_shortlisted
    where(kind: "not_shortlisted_notifier")
  end

  def self.not_awarded
    where(kind: "unsuccessful_group_leaders_notification")
  end

  private

  def clear_cache
    Rails.cache.delete("current_settings")
    Rails.cache.delete("current_award_year")
    Rails.cache.delete("#{kind.value}_notification")
  end
end

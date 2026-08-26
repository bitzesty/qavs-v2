class Deadline < ApplicationRecord
  extend Enumerize
  include FormattedTime::DateTimeFor

  date_time_for :trigger_at

  belongs_to :settings

  AVAILABLE_DEADLINES = [
    "award_year_switch",
    "submission_start",
    "submission_end",
    "local_assessment_submission_end",
    "buckingham_palace_attendees_details",
    "buckingham_palace_attendees_invite",
    "buckingham_palace_confirm_press_book_notes",
    "buckingham_palace_reception_attendee_information_due_by"
  ]

  enumerize :kind, in: AVAILABLE_DEADLINES, predicates: true
  validates :kind, presence: true

  after_save :clear_cache
  after_destroy :clear_cache

  class << self
    def with_states_to_trigger(time = DateTime.now)
      where(kind: "submission_end", states_triggered_at: nil).where("trigger_at < ?", time)
    end

    def award_year_switch
      where(kind: "award_year_switch").first
    end

    def submission_end
      where(kind: "submission_end")
    end

    def local_assessment_submission_end
      where(kind: "local_assessment_submission_end")
    end

    def submission_start
      where(kind: "submission_start").first
    end

    def end_of_embargo
      where(kind: "buckingham_palace_attendees_details").first
    end

    def buckingham_palace_confirm_press_book_notes
      where(kind: "buckingham_palace_confirm_press_book_notes").first
    end

    def buckingham_palace_attendees_invite
      where(kind: "buckingham_palace_attendees_invite").first
    end

    def buckingham_palace_reception_attendee_information_due_by
      where(kind: "buckingham_palace_reception_attendee_information_due_by").first
    end
  end

  def passed?
    trigger_at && trigger_at < Time.zone.now
  end

  def strftime(format)
    trigger_at ? trigger_at.strftime(format) : "-"
  end

  private

  def clear_cache
    Rails.cache.delete("current_settings")
    Rails.cache.delete("current_award_year")
    Rails.cache.delete("#{kind.value}_deadline")
    Rails.cache.delete("#{kind}_deadline_#{settings.award_year.year}")
    Rails.cache.delete("submission_start_deadlines")
  end
end

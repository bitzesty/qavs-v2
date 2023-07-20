class AwardYearDecorator < ApplicationDecorator
  def winners_notify_date
    object.settings.email_notifications.find_by(kind: "winners_notification")&.trigger_at
  end

  def unsuccessful_notify_date
    object.settings.email_notifications.find_by(kind: "unsuccessful_notification")&.trigger_at
  end
end

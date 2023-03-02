class Users::AwardYearOpenNotificationMailer < ApplicationMailer
  def notify(user_id)
    @user = User.find(user_id)
    subject = "King's Award for Voluntary Service Reminder: applications for the new Award year are open"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email,
         subject: subject_with_env_prefix(subject)
  end
end

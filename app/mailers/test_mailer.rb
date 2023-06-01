class TestMailer < ApplicationMailer
  def welcome(email)
    @email = email
    @subject = "[King's Award for Voluntary Service] test mailer!"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @email, subject: subject_with_env_prefix(@subject)
  end
end

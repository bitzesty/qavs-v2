class LieutenantsMailers::LocalAssessmentReminderMailer < ApplicationMailer
  layout "mailer"

  def notify(lieutenant_id)
    @lieutenant = Lieutenant.find(lieutenant_id)
    @deadline = Settings.current_local_assessment_submission_deadline.strftime("%A %d %B %Y")
    subject = "Reminder to submit your assessments"

    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"],
                             to: @lieutenant.email,
                             subject: subject_with_env_prefix(subject)
  end
end

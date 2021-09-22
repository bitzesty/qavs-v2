class LieutenantsMailers::LocalAssessmentReminderMailer < ApplicationMailer
  layout "mailer"

  def notify(lieutenant_id)
    @lieutenant = Lieutenant.find(lieutenant_id)
    deadline = Settings.current_local_assessment_submission_deadline
    deadline_day = deadline.trigger_at.day
    @deadline = deadline.strftime("%l %P on %A on #{deadline_day.ordinalize} %B %Y")
    subject = "Reminder to submit assessments"

    send_mail_if_not_bounces ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"],
                             to: @lieutenant.email,
                             subject: subject_with_env_prefix(subject)
  end
end

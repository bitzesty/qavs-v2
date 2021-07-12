class LieutenantMailers::LocalAssessmentReminderMailer < ApplicationMailer
  layout "mailer"

  def notify(lieutenant_id)
    @lieutenant = Lieutenant.find(lieutenant_id)
    @deadline = Settings.current_local_assessment_submission_deadline.strftime("%A %d %B %Y")
  end
end

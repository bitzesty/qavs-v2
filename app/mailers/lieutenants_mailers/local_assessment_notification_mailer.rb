class LieutenantsMailers::LocalAssessmentNotificationMailer < ApplicationMailer
  layout "mailer"

  def notify(lieutenant_id)
    @lieutenant = Lieutenant.find(lieutenant_id)
    @total = @lieutenant.ceremonial_county ? @lieutenant.ceremonial_county.form_answers.count : 0
    @award_year = AwardYear.current.year
    subject = "Nominations are ready for you to assess"

    view_mail ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"],
                             to: @lieutenant.email,
                             subject: subject_with_env_prefix(subject)
  end
end

class LieutenantMailers::LocalAssessmentNotificationMailer < ApplicationMailer
  layout "mailer"

  def notify(lieutenant_id)
    @lieutenant = Lieutenant.find(lieutenant_id)
    @current_year = AwardYear.current.year
  end
end

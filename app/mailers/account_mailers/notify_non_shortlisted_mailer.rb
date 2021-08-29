class AccountMailers::NotifyNonShortlistedMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, collaborator_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = form_answer.user.decorate
    collaborator = User.find(collaborator_id)

    @current_year = @form_answer.award_year.year
    @subject = "Queen's Award for Voluntary Service: Thank you for applying"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: collaborator.email, subject: subject_with_env_prefix(@subject)
  end
end

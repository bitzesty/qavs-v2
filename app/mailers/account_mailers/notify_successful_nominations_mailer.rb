class AccountMailers::NotifySuccessfulNominationsMailer < AccountMailers::BaseMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate
    @user_name = @user.full_name
    @subject = "Your nomination for Queen’s Award for Voluntary Service"
    @group_name = form_answer.document["nomination_local_assessment_form_nominee_name"]

    deadlines = Settings.current.deadlines
    @end_of_embargo_date = deadlines.end_of_embargo.strftime("%-d %B")

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email, subject: subject_with_env_prefix(@subject)
  end
end

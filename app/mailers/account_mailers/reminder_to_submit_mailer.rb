class AccountMailers::ReminderToSubmitMailer < AccountMailers::BaseMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @user = @form_answer.user
    @deadline = Settings.current_submission_deadline.decorate.long_mail_reminder
    @user_name = @user.full_name
    subject = "KAVS nomination - reminder to submit"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @user.email, subject: subject_with_env_prefix(subject)
  end
end

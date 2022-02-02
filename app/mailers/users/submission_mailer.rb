class Users::SubmissionMailer < ApplicationMailer
  helper(ApplicationHelper)

  def success(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @form_owner = @form_answer.user.decorate
    @recipient = User.find(user_id).decorate
    @subject = "QAVS Nomination Received"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @recipient.email, subject: subject_with_env_prefix(@subject)
  end
end

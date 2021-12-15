class AccountMailers::GroupLeaderMailer < AccountMailers::BaseMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id)
    @group_leader_email = @form_answer.document["nominee_leader_email"]
    @group_leader_name = @form_answer.document["nominee_leader_name"]
    @group_name = @form_answer.document["nominee_name"]
    subject = "Nomination for Queen’s Award for Voluntary Service"
    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @group_leader_email, subject: subject_with_env_prefix(subject)
  end
end

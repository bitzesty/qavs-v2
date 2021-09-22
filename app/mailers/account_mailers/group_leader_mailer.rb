class AccountMailers::GroupLeaderMailer < AccountMailers::BaseMailer
  def notify(email, name, group_name)
    @form_answer = form_answer
    @group_leader_name = name
    @group_name = group_name
    subject = "Nomination for Queen’s Award for Voluntary Service"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: email, subject: subject_with_env_prefix(subject)
  end
end

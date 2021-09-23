class GroupLeadersMailers::UnsuccessfulNominationMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @group_leader_name = @form_answer.document["local_assessment_group_leader"]
    @group_name = @form_answer.document["nomination_local_assessment_form_nominee_name"]
    @group_leader_email = @form_answer.document["local_assessment_group_leader_email"]
    @award_year = @form_answer.award_year.year

    @subject = "Queen’s Award for Voluntary Service #{ @award_year }"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @group_leader_email, subject: subject_with_env_prefix(@subject)
  end
end

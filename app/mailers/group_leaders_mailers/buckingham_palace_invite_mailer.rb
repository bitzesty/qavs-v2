class GroupLeadersMailers::BuckinghamPalaceInviteMailer < AccountMailers::BaseMailer
  def invite(form_answer_id, gl_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @group_leader = GroupLeader.find(gl_id)
    @group_leader_name = "#{@group_leader.first_name} #{@group_leader.last_name}"
    @group_leader_email = @form_answer.document["local_assessment_group_leader_email"]
    @award_year = @form_answer.award_year.year

    deadlines = Settings.current.deadlines

    @palace_invite_deadline = deadlines.buckingham_palace_reception_attendee_information_due_by.decorate.formatted_mailer_deadline

    @subject = "QAVS Invitations to a Royal Garden Party - action required"

    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @group_leader_email, subject: subject_with_env_prefix(@subject)
  end
end

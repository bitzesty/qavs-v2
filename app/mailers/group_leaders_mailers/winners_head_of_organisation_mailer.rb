class GroupLeadersMailers::WinnersHeadOfOrganisationMailer < ApplicationMailer
  def notify(form_answer_id, gl_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @group_leader = GroupLeader.find(gl_id)
    @group_leader_name = "#{@group_leader.first_name} #{@group_leader.last_name}"
    @group_name = @form_answer.document["nomination_local_assessment_form_nominee_name"]
    @group_leader_email = @form_answer.document["local_assessment_group_leader_email"]
    @award_year = @form_answer.award_year.year
    @token = @group_leader.send(:set_reset_password_token)

    deadlines = Settings.current.deadlines

    @end_of_embargo_date = deadlines.end_of_embargo.strftime("%-d %B")
    @citation_deadline = deadlines.buckingham_palace_confirm_press_book_notes.strftime("%-d %B")

    @subject = "Queen’s Award for Voluntary Service - in confidence"

    view_mail ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @group_leader_email, subject: subject_with_env_prefix(@subject)
  end
end

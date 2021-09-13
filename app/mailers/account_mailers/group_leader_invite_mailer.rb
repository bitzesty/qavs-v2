# coding: utf-8
class AccountMailers::GroupLeaderInviteMailer < AccountMailers::BaseMailer
  def notify(form_answer_id, gl_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @group_leader = GroupLeader.find(gl_id)
    @token = @group_leader.send(:set_reset_password_token)

    @name = "#{@group_leader.first_name} #{@group_leader.last_name}"

    # deadlines = Settings.current.deadlines
    # @deadline = deadlines.where(kind: "buckingham_palace_attendees_details").first
    # @deadline = @deadline.trigger_at

    # @media_deadline = deadlines.where(kind: "buckingham_palace_media_information").first
    # @media_deadline = @media_deadline.try :strftime, "%A %d %B %Y"

    # @book_notes_deadline = deadlines.where(kind: "buckingham_palace_confirm_press_book_notes").first
    # @book_notes_deadline = @book_notes_deadline.try :strftime, "%A %d %B %Y"

    subject = "Important information about your Queen’s Award"
    send_mail_if_not_bounces ENV['GOV_UK_NOTIFY_API_TEMPLATE_ID'], to: @group_leader.email, subject: subject_with_env_prefix(subject)
  end
end

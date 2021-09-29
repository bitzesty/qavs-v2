class GroupLeader::DashboardController < GroupLeader::BaseController
  def show
    authorize :group_leader_dashboard, :show?
    @citation = current_subject.form_answer.citation
    @invite = palace_invite
    @end_of_embargo = Settings.current.deadlines.end_of_embargo
    @citation_deadline = Settings.current.deadlines.buckingham_palace_confirm_press_book_notes
    @party_invite_deadline = Settings.current.deadlines.buckingham_palace_reception_attendee_information_due_by
  end

  private

  def palace_invite
    current_subject.form_answer.palace_invite || PalaceInvite.create!(form_answer: current_subject.form_answer)
  end
end

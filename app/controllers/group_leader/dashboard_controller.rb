class GroupLeader::DashboardController < GroupLeader::BaseController
  def index
    authorize :group_leader_dashboard, :index?
    @citation = current_subject.form_answer.citation
    @invite = palace_invite

    @deadlines = Settings.current.deadlines
  end

  private

  def palace_invite
    current_subject.form_answer.palace_invite || PalaceInvite.create!(form_answer: current_subject.form_answer)
  end
end

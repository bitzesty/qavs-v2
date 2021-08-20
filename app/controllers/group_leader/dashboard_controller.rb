class GroupLeader::DashboardController < GroupLeader::BaseController
  def show
    authorize :group_leader_dashboard, :show?
    @citation = current_subject.form_answer.citation
    @invite = palace_invite
  end

  private

  def palace_invite
    current_subject.form_answer.palace_invite || PalaceInvite.create!(form_answer: current_subject.form_answer)
  end
end

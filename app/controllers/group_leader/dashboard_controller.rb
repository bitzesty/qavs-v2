class GroupLeader::DashboardController < GroupLeader::BaseController
  def show
    authorize :group_leader_dashboard, :show?
    @citation = current_subject.form_answer.citation
    @invite = current_subject.form_answer.palace_invite
  end
end

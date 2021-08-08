class GroupLeader::DashboardController < GroupLeader::BaseController
  def show
    authorize :group_leader_dashboard, :show?
    @citation = current_subject.citation
    # TODO
    @invite = PalaceInvite.first
  end
end

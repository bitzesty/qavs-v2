class GroupLeader::DashboardController < GroupLeader::BaseController
  def show
    authorize :group_leader_dashboard, :show?
  end
end

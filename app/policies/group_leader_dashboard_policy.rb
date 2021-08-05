class GroupLeaderDashboardPolicy < ApplicationPolicy
  def show?
    group_leader?
  end
end

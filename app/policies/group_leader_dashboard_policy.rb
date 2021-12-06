class GroupLeaderDashboardPolicy < ApplicationPolicy
  def index?
    group_leader?
  end
end

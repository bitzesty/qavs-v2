class GroupLeaderPolicy < ApplicationPolicy
  def update
    group_leader?
  end
end

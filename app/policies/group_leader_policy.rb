class GroupLeaderPolicy < AdminPolicy
  def index?
    admin?
  end

  def create?
    false
  end

  def update?
    admin? || group_leader?
  end

  def destroy?
    admin?
  end
end

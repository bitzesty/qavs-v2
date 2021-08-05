class GroupLeaderPolicy < AdminPolicy
  def index?
    admin?
  end

  def create?
    false
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end
end

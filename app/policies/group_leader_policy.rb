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

  def update_account_details?
    admin? || group_leader?
  end
end

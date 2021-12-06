class LieutenantDashboardPolicy < ApplicationPolicy
  def index?
    lieutenant?
  end
end

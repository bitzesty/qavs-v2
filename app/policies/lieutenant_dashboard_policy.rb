class LieutenantDashboardPolicy < ApplicationPolicy
  def show?
    lieutenant?
  end
end

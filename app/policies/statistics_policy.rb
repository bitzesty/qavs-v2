class StatisticsPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def send?
    admin?
  end
end

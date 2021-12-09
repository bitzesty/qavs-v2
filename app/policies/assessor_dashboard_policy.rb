class AssessorDashboardPolicy < ApplicationPolicy
  def index?
    assessor?
  end
end

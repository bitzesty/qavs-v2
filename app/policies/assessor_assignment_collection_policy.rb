class AssessorAssignmentCollectionPolicy < ApplicationPolicy
  def create?
    admin?
  end
end

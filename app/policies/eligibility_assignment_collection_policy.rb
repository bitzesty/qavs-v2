class EligibilityAssignmentCollectionPolicy < ApplicationPolicy
  def create?
    admin?
  end
end

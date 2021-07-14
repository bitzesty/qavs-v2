class LieutenantAssignmentCollectionPolicy < ApplicationPolicy
  def create?
    admin?
  end
end

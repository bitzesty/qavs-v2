class SupportLetterPolicy < ApplicationPolicy
  # TODO: needs clarification

  def show?
    true
  end

  def can_remove?
    admin?
  end
end

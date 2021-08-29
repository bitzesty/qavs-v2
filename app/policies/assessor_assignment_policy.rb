class AssessorAssignmentPolicy < ApplicationPolicy
  def show?
    admin? || record.editable_for?(subject) || record.submitted?
  end

  def update?
    record.editable_for?(subject) && !record.locked?
  end

  def create?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin?

    record.editable_for?(subject) && record.valid_for_submission?
  end

  def can_be_submitted?
    submit? && !record.submitted?
  end

  def can_be_re_submitted?
    submit? && record.submitted? && !record.locked?
  end

  def can_unlock?
    record.locked? && admin?
  end
end

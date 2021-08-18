class AssessorAssignmentPolicy < ApplicationPolicy
  def update?
    record.editable_for?(subject)
  end

  def create?
    record.editable_for?(subject)
  end

  def submit?
    return true if admin?

    record.editable_for?(subject)
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

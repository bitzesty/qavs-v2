class AssessorAssignmentPolicy < ApplicationPolicy
  def show?
    admin? || record.editable_for?(subject) || (record.submitted? && own_assignment_submitted?(subject, record))
  end

  def own_assignment_submitted?(subject, record)
    own_assignment = record.form_answer.assessor_assignments.where(assessor_id: subject.id).first

    own_assignment && own_assignment.submitted?
  end

  def update?
    record.editable_for?(subject) && !record.locked?
  end

  def create?
    record.editable_for?(subject)
  end

  def submit?
    (admin? || record.editable_for?(subject)) && record.valid_for_submission?
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

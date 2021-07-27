class FormAnswerStateTransitionPolicy < ApplicationPolicy
  def create?
    return true if admin?
    return true if record.state == "assessment_in_progress"
    return false if lieutenant?
    subject.lead?(record.form_answer)
  end

  def view_dropdown?
    return true if admin?
    return true if record.state == "submitted"
    return false if lieutenant?
    subject.lead?(record.form_answer)
  end
end

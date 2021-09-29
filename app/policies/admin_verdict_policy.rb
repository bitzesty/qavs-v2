class AdminVerdictPolicy < ApplicationPolicy
  def create?
    admin? && states_valid_for_verdict.include?(record.form_answer.state.to_sym)
  end

  def update?
    create?
  end

  private

  def states_valid_for_verdict
    [:local_assessment_recommended] + FormAnswerStateMachine::FINAL_VERDICT_STATES
  end
end

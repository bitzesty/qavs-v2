class DisqualifiedDeadlineStatesTransitionWorker
  include Cloudtasker::Worker

  def perform
    FormAnswerStateMachine.trigger_audit_deadlines
  end
end

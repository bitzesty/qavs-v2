class SubmissionDeadlineStatesTransitionWorker
  include Cloudtasker::Worker

  def perform
    FormAnswerStateMachine.trigger_deadlines
  end
end

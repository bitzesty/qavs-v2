class AssessmentSubmissionService
  attr_reader :resource, :current_subject

  def initialize(assignment, current_subject)
    @resource = assignment
    @current_subject = current_subject
  end

  delegate :form_answer, to: :resource

  def perform
    resource.submission_action = true

    if resource.submitted?
      resubmit!
    else
      submit_assessment
    end
  end

  def resubmit!
    set_submitted_at_as_now!
  end

  delegate :as_json, to: :resource

  private

  def submit_assessment
    set_submitted_at_as_now!
  end

  def set_submitted_at_as_now!
    resource.update(
      submitted_at: DateTime.now,
      locked_at: DateTime.now
    )
  end
end

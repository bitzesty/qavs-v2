module AssessmentSubmissionMixin
  def create
    authorize resource, :submit?
    @service = AssessmentSubmissionService.new(resource, current_subject)
    @service.perform
    log_event if resource.reload.locked_at.present?
    @assessment = @service.resource

    respond_to do |format|
      format.html do
        redirect_to [namespace_name, resource.form_answer]
      end
    end
  end

  def unlock
    authorize resource, :can_unlock?
    resource.update_column(:locked_at, nil)
    log_event

    redirect_to [namespace_name, resource.form_answer]
  end

  def action_type
    appraisal_type = "appraisal"
    appraisal_action = action_name == "create" ? "submit" : "unsubmit"
    "#{appraisal_type}_#{appraisal_action}"
  end

  def form_answer
    resource.form_answer
  end

  private

  def resource
    @assignment ||= AssessorAssignment.find(params[:assessment_id])
  end
end

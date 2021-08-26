module AssessorAssignmentContext
  def create
    assessor = Assessor.find(params[:assessor_id])
    assignment = form_answer.assessor_assignments.build(assessor: assessor, award_year: @award_year)

    assessment = AssessorAssignmentService.new(params, current_subject, assignment)
    authorize assessment.resource, :create?
    assessment.save

    respond_to do |format|
      format.js do
        @assessment = assessment.resource
        render template: "assessor/assessor_assignments/update", layout: false, content_type: 'text/javascript'
      end

      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?
    assessment.save

    respond_to do |format|
      format.js do
        @assessment = assessment.resource
        @form_answer = @assessment.form_answer
        render layout: false, content_type: 'text/javascript'
      end

      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  private

  def assessor_assignment
    AssessorAssignment.find(params[:id])
  end

  def form_answer
    @form_answer ||= if params[:id]
      assessor_assignment.form_answer
    elsif params[:form_answer_id]
      @award_year.form_answers.find(params[:form_answer_id])
    end
  end

  def action_type
    "appraisal_update"
  end
end

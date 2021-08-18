module AssessorAssignmentContext
  def create
    assessor = Assessor.find(params[:assessor_id])
    assignment = form_answer.assessor_assignments.build(assessor: assessor, award_year: @award_year)

    assessment = AssessorAssignmentService.new(params, current_subject, assignment)
    authorize assessment.resource, :create?

    respond_to do |format|
      if assessment.save
        log_event
        format.json { render json: { errors: [], id: assessment.resource.id } }
      else
        format.json { render status: :unprocessable_entity,
                             json: { errors: assessment.resource.errors } }
        Appsignal.send_error(Exception.new("Failed to save `AssessorAssignment for FormAnswer##{form_answer.id}. \n #{assessment.resource.errors} \n #{params}"))
      end

      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def update
    assessment = AssessorAssignmentService.new(params, current_subject)
    authorize assessment.resource, :update?

    respond_to do |format|
      if assessment.save
        log_event
        format.json { render json: { errors: [], id: assessment.resource.id } }
      else
        format.json { render status: :unprocessable_entity,
                             json: { errors: assessment.resource.errors } }
        Appsignal.send_error(Exception.new("Failed to save `AssessorAssignment##{assessor_assignment.id}. \n #{assessment.resource.errors} \n #{params}"))
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

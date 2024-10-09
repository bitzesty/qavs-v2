class Admin::EligibilityAssignmentCollectionsController < Admin::BaseController
  def create
    @form = EligibilityAssignmentCollection.new(create_params)
    authorize @form, :create?

    @form.subject = current_subject

    if @form.save
      redirect_to admin_form_answers_path(year: params[:year], search_id: params[:search_id]), notice: @form.notice_message
    else
      # Ensure form_answer_ids is an array
      @form.form_answer_ids = @form.form_answer_ids.split(",") if @form.form_answer_ids.is_a?(String)
      render "admin/form_answers/bulk_assign_eligibility"
    end
  end

  private

  def create_params
    params.require(:eligibility_assignment_collection)
          .permit(:form_answer_ids, :state)
  end
end

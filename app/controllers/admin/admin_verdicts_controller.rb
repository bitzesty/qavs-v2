class Admin::AdminVerdictsController < Admin::BaseController
  def create
    @admin_verdict = form_answer.admin_verdict || form_answer.build_admin_verdict

    authorize @admin_verdict

    @admin_verdict.attributes = verdict_params

    if @admin_verdict.save
      redirect_to [:admin, form_answer], success: "National assessment and Royal approval outcome successfully saved."
    else
      render template: "admin/form_answers/show"
    end
  end

  def update
    @admin_verdict = form_answer.admin_verdict

    authorize @admin_verdict

    @admin_verdict.attributes = verdict_params

    @admin_verdict.save

    if @admin_verdict.save
      redirect_to [:admin, form_answer], success: "National assessment and Royal approval outcome successfully saved."
    else
      render template: "admin/form_answers/show"
    end
  end

  private

  def verdict_params
    params.require(:admin_verdict).permit(
      :outcome,
      :description
    )
  end

  def form_answer
    @form_answer ||= FormAnswer.find(params[:form_answer_id])
  end

  def resource
    form_answer.decorate
  end
  helper_method :resource
end

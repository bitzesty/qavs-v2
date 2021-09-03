module FormAnswerMixin
  def update
    check_rigths_by_updating_options

    resource.assign_attributes(allowed_params.except(:data_attributes))
    resource.data_attributes = allowed_params[:data_attributes].except(:id) if allowed_params[:data_attributes]
    resource.company_details_updated_at = DateTime.now
    resource.company_details_editable = current_subject

    resource.save

    respond_to do |format|
      format.json do
        render json: {
          form_answer: {
            sic_codes: resource.decorate.all_average_growths,
            legend: resource.decorate.average_growth_legend,
            ceremonial_county_name: resource.ceremonial_county.try(:name),
            ceremonial_county_id: resource.ceremonial_county.try(:id)
          }
        }
      end

      format.html do
        if request.xhr?
          render partial: "admin/form_answers/company_details/#{params[:section]}_form", layout: false
        else
          redirect_to [namespace_name, resource]
        end
      end
    end
  end

  def show
    authorize resource, :show?
  end

  def review
    authorize resource, :review?
    sign_in(@form_answer.user, scope: :user, skip_session_limitable: true)
    session[:admin_in_read_only_mode] = true

    redirect_to edit_form_path(@form_answer)
  end

  private

  def allowed_params
    ops = params.require(:form_answer).permit!
    ops = ops.to_h

    ops.reject! do |k, v|
      (k.to_sym == :company_or_nominee_name || k.to_sym == :nominee_title) &&
      !CompanyDetailPolicy.new(pundit_user, resource).can_manage_company_name?
    end

    ops
  end

  def its_previous_wins_update?
    params[:section] == "previous_wins"
  end

  def its_sic_code_update?
    params[:section] == "sic_code"
  end

  def lieutenancy_update?
    params[:section] == "lieutenancy"
  end

  def check_rigths_by_updating_options
    if its_previous_wins_update? || its_sic_code_update?
      authorize resource, :can_update_by_admin_lead_and_primary_assessors?
    elsif lieutenancy_update?
      authorize resource, :assign_lieutenancy?
    else
      authorize resource, :update?
    end
  end

  def load_resource
    @form_answer = FormAnswer.find(params[:id]).decorate
  end

  def financial_data_ops
    {
      updated_at: Time.zone.now,
      updated_by_id: pundit_user.id,
      updated_by_type: pundit_user.class
    }.merge(params[:financial_data].permit!)
  end
end

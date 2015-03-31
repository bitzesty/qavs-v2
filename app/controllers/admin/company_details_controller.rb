class Admin::CompanyDetailsController < Admin::BaseController
  def update
    @company_detail = CompanyDetail.find(params[:id])

    authorize @company_detail, :update?
    @company_detail.update(update_params)
    @form_answer = @company_detail.form_answer.decorate

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: "admin/form_answers/company_details/address_form", layout: false
        else
          redirect_to [namespace_name, resource]
        end
      end
    end
  end

  helper_method :resource

  private

  def update_params
    params.require(:company_detail).permit :address_building,
                                           :address_street,
                                           :address_city,
                                           :address_country,
                                           :address_postcode,
                                           :telephone,
                                           :region
  end

  def resource
    @form_answer ||= @company_detail.form_answer
  end
end

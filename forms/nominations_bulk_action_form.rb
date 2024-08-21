class NominationsBulkActionForm
  attr_reader :params
  include Rails.application.routes.url_helpers

  def initialize(params)
    @params = params
  end

  def kind
    @kind ||= if params[:bulk_assign_lieutenants]
      "lieutenants"
    elsif params[:bulk_assign_assessors]
      "assessors"
    elsif params[:bulk_assign_eligibility]
      "eligibility"
    end
  end

  def valid?
    if !params[:bulk_action].present?
      errors.add(:bulk_base, "You must select at least one group from the list below before clicking a bulk action button.")

      return false
    end

    case kind
    when "lieutenants"
      params[:bulk_action].present?
    when "assessors"
      params[:bulk_action].present?
    when "eligibility"
      params[:bulk_action].present?
    end
  end

  def redirect_url
    case kind
    when "lieutenants"
      bulk_assign_lieutenants_admin_form_answers_path(params: params)
    when "assessors"
      bulk_assign_assessors_admin_form_answers_path(params: params)
    when "eligibility"
      bulk_assign_eligibility_admin_form_answers_path(params: params)
    end
  end
end

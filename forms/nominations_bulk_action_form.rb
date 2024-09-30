class NominationsBulkActionForm
  attr_reader :params, :errors, :search_id
  include Rails.application.routes.url_helpers

  def initialize(params)
    @params = save_search_and_clean_params(params)
    @errors = ActiveModel::Errors.new(self)
    @kind = determine_kind
  end

  def valid?
    if !params[:bulk_action].present?
      @errors.add(:bulk_base, "You must select at least one group from the list below before clicking a bulk action button.")
      return false
    end

    case @kind
    when "lieutenants", "assessors"
      params[:bulk_action].present?
    when "eligibility"
      params[:bulk_action].present? && form_answers_eligible_for_state_change?
    else
      @errors.add(:bulk_base, "Invalid bulk action type.")
      false
    end
  end

  def base_error_messages
    @errors[:bulk_base].join(" ")
  end

  def redirect_url
    case @kind
    when "lieutenants"
      bulk_assign_lieutenants_admin_form_answers_path(params: params)
    when "assessors"
      bulk_assign_assessors_admin_form_answers_path(params: params)
    when "eligibility"
      bulk_assign_eligibility_admin_form_answers_path(params: params)
    else
      # Handle invalid kind
      raise "Invalid bulk action type."
    end
  end

  def determine_kind
    if params[:bulk_assign_lieutenants]
      "lieutenants"
    elsif params[:bulk_assign_assessors]
      "assessors"
    elsif params[:bulk_assign_eligibility]
      "eligibility"
    end
  end

  private

  def save_search_and_clean_params(params)
    if params[:search] && params[:search][:search_filter] != FormAnswerSearch.default_search[:search_filter]
      search = NominationSearch.create(serialized_query: params[:search].to_json)
      @search_id = search.id
      params[:search_id] = search.id
      params[:search] = nil
      params[:authenticity_token] = nil
    end

    params
  end

  def form_answers_eligible_for_state_change?
    if FormAnswer.where(id: params[:bulk_action][:ids]).all? do |form_answer|
         EligibilityAssignmentCollection::VALID_STATES.include?(form_answer.state)
       end
      true
    else
      @errors.add(:bulk_base, "To assign the eligibility status, you must only select groups that currently have ‘Nomination submitted’ or ‘Eligibility pending’ status.")
      false
    end
  end
end

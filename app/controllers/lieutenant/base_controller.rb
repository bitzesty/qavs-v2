class Lieutenant::BaseController < ApplicationController
  include Pundit

  helper_method :namespace_name, :current_subject

  layout "application-lieutenant"

  before_action :authenticate_lieutenant!, :load_award_year_and_settings
  after_action :verify_authorized

  skip_before_action :authenticate_user!, raise: false
  skip_before_action :restrict_access_if_admin_in_read_only_mode!, raise: false

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_lieutenant
  end

  def current_subject
    current_lieutenant
  end

  private

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(lieutenant_root_path)
  end

  def namespace_name
    :lieutenant
  end


  def user_for_paper_trail
    "LIEUTENANT:#{current_subject.id}" if current_subject.present?
  end
end

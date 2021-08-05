class GroupLeader::BaseController < ApplicationController
  include Pundit

  helper_method :namespace_name, :current_subject

  layout "application"

  before_action :authenticate_group_leader!, :load_award_year_and_settings
  after_action :verify_authorized

  skip_before_action :authenticate_user!, raise: false
  skip_before_action :restrict_access_if_admin_in_read_only_mode!, raise: false

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_group_leader
  end

  def current_subject
    current_group_leader
  end

  private

  def user_not_authorized
    flash.alert = "You are not authorized to perform this action."
    redirect_to(group_leader_root_path)
  end

  def namespace_name
    :group_leader
  end

  def user_for_paper_trail
    "GROUPLEADER:#{current_subject.id}" if current_subject.present?
  end
end

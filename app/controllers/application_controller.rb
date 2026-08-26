require "app_responder"
include AuditHelper

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  add_flash_types :success, :success_template

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_context_tags
  before_action :set_paper_trail_whodunnit
  before_action :disable_browser_caching!

  self.responder = AppResponder
  respond_to :html

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      custom_redirect_url = session[:custom_redirect]

      if custom_redirect_url.present?
        session[:custom_redirect] = nil
        custom_redirect_url
      else
        dashboard_path
      end
    else
      super
    end
  end

  def admin_in_read_only_mode?
    @admin_in_read_only_mode ||= (admin_signed_in? || assessor_signed_in?) &&
                                 session["warden.user.user.key"] &&
                                 session[:admin_in_read_only_mode]
  end
  helper_method :admin_in_read_only_mode?

  def restrict_access_if_admin_in_read_only_mode!
    if admin_in_read_only_mode?
      if request.referer
        flash[:alert] = "You have no permissions!"
        redirect_back(fallback_location: root_path)
      else
        render text: "You have no permissions!"
      end
      return
    end
  end

  def current_account
    current_user && current_user.account
  end
  helper_method :current_account

  def should_enable_js?
    browser = Browser.new(request.env['HTTP_USER_AGENT'], accept_language: "en-gb")

    !browser.ie? || browser.ie?([">8"])
  end
  helper_method :should_enable_js?

  protected

  def settings
    Rails.cache.fetch("current_settings", expires_in: 1.minute) do
      AwardYear.current.settings
    end
  end

  def submission_started?
    Settings.current_submission_start_deadline.try(:passed?)
  end
  helper_method :submission_started?

  def submission_started_deadlines
    Settings.current_submission_start_deadlines
  end

  def submission_ended?
    submission_deadline.passed?
  end
  helper_method :submission_ended?

  def current_form_submission_ended?
    return false if current_admin.present? && current_admin.superadmin?
    Rails.cache.fetch("form_submission_ended_#{@form_answer.id}", expires_in: 1.minute) do
      @form_answer.submission_ended?
    end
  end
  helper_method :current_form_submission_ended?

  def submission_started_deadline
    Settings.current_submission_start_deadline
  end
  helper_method :submission_started_deadline

  def submission_deadline
    Settings.current_submission_deadline
  end
  helper_method :submission_deadline

  def local_assessment_submission_deadline
    Settings.current_local_assessment_submission_deadline
  end
  helper_method :local_assessment_submission_deadline

  def log_action(action_type)
    AuditLog.create!(subject: current_subject, action_type: action_type)
  end

  def log_event
    AuditLog.create!(
      subject: current_subject,
      auditable: form_answer,
      action_type: action_type
      )
  end

  def current_subject
    current_user || dummy_user
  end
  helper_method :current_subject

  def current_form_user
    current_user || current_lieutenant || current_admin || current_assessor
  end
  helper_method :current_form_user

  #
  # Disabling browser caching in order
  # to protect sensitive data
  #
  def disable_browser_caching!
    return true if request.path.include?("/assets/") || request.path.include?("/packs/")
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end

  def set_context_tags
    context = { current_user: current_user.try(:id) }
    Appsignal.tag_request(context)
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
    when :admin
      new_admin_session_path
    when :assessor
      new_assessor_session_path
    when :lieutenant
      new_lieutenant_session_path
    else
      new_user_session_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :agreed_with_privacy_policy
      ]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :email,
        :current_password,
        :password,
        :password_confirmation,
        :completed_registration,
        :title,
        :first_name,
        :last_name,
        :job_title,
        :phone_number,
        :company_name,
        :company_address_first,
        :company_address_second,
        :company_city,
        :company_country,
        :company_postcode,
        :company_phone_number,
        :prefered_method_of_contact,
        :subscribed_to_emails,
        :agree_being_contacted_by_department_of_business
      ]
    )
  end

  def require_to_be_account_admin!
    unless current_user.account_admin?
      redirect_to dashboard_path,
                  notice: "Access denied!"
    end
  end

  def load_award_year_and_settings
    if params[:year].present? && AwardYear::AVAILABLE_YEARS.include?(params[:year].to_i)
      @award_year = AwardYear.for_year(params[:year].to_i).first_or_create
    else
      @award_year = AwardYear.current
    end

    @settings = @award_year.settings
    @deadlines = @settings.deadlines.to_a
  end

  def user_for_paper_trail
    if current_admin.present? && current_admin.superadmin?
      "ADMIN:#{current_admin.id}"
    elsif current_user.present?
      "USER:#{current_user.id}"
    end
  end
end

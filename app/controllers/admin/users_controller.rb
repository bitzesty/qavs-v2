class Admin::UsersController < Admin::BaseController
  respond_to :html
  before_action :find_resource, except: [:index, :new, :create]
  before_action :permit_search_params, except: [:index]

  def index
    params[:search] ||= UserSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize User, :index?

    @search = UserSearch.new(User.all).search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = User.new
    authorize @resource, :create?
  end

  def edit
    authorize @resource, :update?
  end

  def create
    @resource = User.new(resource_params)
    @resource.skip_password_validation = true
    @resource.agreed_with_privacy_policy = "1"
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_users_path(search: params[:search], page: params[:page]) : nil
    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update_with_password(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource, location: admin_users_path(search: params[:search], page: params[:page])
  end

  def resend_confirmation_email
    authorize @resource, :update?

    @resource.send_confirmation_instructions
    flash[:success] = "Confirmation instructions were successfully sent to #{@resource.decorate.full_name} (#{@resource.email})"
    respond_with :admin, @resource,
                 location: admin_users_path(search: params[:search], page: params[:page])
  end

  def unlock
    authorize @resource, :update?

    @resource.unlock_access!
    flash[:success] = "User #{@resource.decorate.full_name} (#{@resource.email}) successfully unlocked!"
    respond_with :admin, @resource,
                 location: edit_admin_user_path(@resource, search: params[:search], page: params[:page])
  end

  def log_in
    authorize @resource
    @resource.update_column(:confirmed_at, Time.zone.now)
    sign_in(@resource, scope: :user, skip_session_limitable: true)
    session[:admin_in_read_only_mode] = false
    session[:admin_in_nomination_mode] = true

    redirect_to dashboard_path
  end

  private

  def find_resource
    @resource = User.find(params[:id])
  end

  def resource_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def permit_search_params
    params[:search].permit! if params[:search].present?
  end
end

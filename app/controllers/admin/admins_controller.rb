class Admin::AdminsController < Admin::UsersController
  before_action :find_resource, except: [:index, :new, :create, :login_as_assessor, :login_as_user, :console]
  before_action :permit_search_params, except: [:index]

  def index
    params[:search] ||= AdminSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize Admin, :index?
    @search = AdminSearch.new(Admin.all).
                         search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Admin.new
    authorize @resource, :create?
  end

  def create
    @resource = Admin.new(resource_params)
    @resource.skip_password_validation = true

    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_admins_path(search: params[:search], page: params[:page]) : nil
    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin,
                 @resource,
                 location: admin_admins_path(search: params[:search], page: params[:page])
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin,
                @resource,
                location: admin_admins_path(search: params[:search], page: params[:page])
  end

  # NOTE: debug abilities for Admin - BEGIN
  def login_as_assessor
    authorize Admin, :index?
    assessor = Assessor.find_by_email(params[:email])
    sign_in(assessor, scope: :assessor, skip_session_limitable: true)

    redirect_to assessor_root_path
  end

  def login_as_user
    authorize Admin, :index?
    user = User.find_by_email(params[:email])
    sign_in(user, scope: :user, skip_session_limitable: true)

    redirect_to dashboard_url
  end

  def console
    authorize Admin, :index?
  end
  # NOTE: debug abilities for Admin - END

  private

  def find_resource
    @resource = Admin.find(params[:id])
  end

  def resource_params
    params.require(:admin).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name)
  end

  def permit_search_params
    params[:search].permit! if params[:search].present?
  end
end

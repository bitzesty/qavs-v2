class Admin::LieutenantsController < Admin::UsersController
  before_action :find_resource, except: [:index, :new, :create, :deleted, :restore]
  before_action :permit_search_params, except: [:index]

  def index
    params[:search] ||= LieutenantSearch.default_search
    params[:search].permit!
    authorize :lieutenant, :index?

    @search = LieutenantSearch.new(Lieutenant.all)
                .search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def deleted
    authorize :lieutenant, :restore?

    @search = LieutenantSearch.new(Lieutenant.deleted)
                .search(params[:search])
    @resources = @search.results.page(params[:page])
    render :index
  end

  def new
    @resource = Lieutenant.new
    authorize @resource, :create?
  end

  def create
    @resource = Lieutenant.new(resource_params)
    @resource.skip_password_validation = true

    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_lieutenants_path(search: params[:search], page: params[:page]) : nil
    respond_with :admin,
                 @resource,
                 location: location,
                 notice: "User has been successfully added."
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
                 location: admin_lieutenants_path(search: params[:search], page: params[:page]),
                 notice: "User has been successfully updated."
  end

  def restore
    @resource = Lieutenant.deleted.find(params[:id])

    authorize @resource, :restore?
    @resource.restore!

    respond_with :admin,
                 @resource,
                 location: admin_lieutenants_path(search: params[:search], page: params[:page]),
                 notice: "User has been successfully restored."
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin,
                 @resource,
                 location: admin_lieutenants_path(search: params[:search], page: params[:page])
  end

  private

  def find_resource
    @resource = Lieutenant.find(params[:id])
  end

  def resource_params
    params.require(:lieutenant).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name,
             :role,
             :ceremonial_county_id)
  end

  def permit_search_params
    params[:search].permit! if params[:search].present?
  end
end

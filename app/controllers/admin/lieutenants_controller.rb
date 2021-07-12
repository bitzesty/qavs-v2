class Admin::LieutenantsController < Admin::UsersController
  def index
    params[:search] ||= LieutenantSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :lieutenant, :index?

    @search = LieutenantSearch.new(Lieutenant.all).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Lieutenant.new
    authorize @resource, :create?
  end

  def create
    @resource = Lieutenant.new(resource_params)
    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_lieutenants_path : nil
    respond_with :admin, @resource, location: location
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :admin, @resource, location: admin_lieutenants_path
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin, @resource, location: admin_lieutenants_path
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
end

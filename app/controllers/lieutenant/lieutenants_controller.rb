class Lieutenant::LieutenantsController < Lieutenant::BaseController
  respond_to :html
  before_action :find_resource, except: [:index, :new, :create]

  def index
    authorize :lieutenant, :index?

    params[:search] ||= LieutenantSearch::DEFAULT_SEARCH
    params[:search].permit!

    @search = LieutenantSearch.new(Lieutenant.from_county(current_lieutenant.ceremonial_county)).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Lieutenant.new
    authorize @resource, :create?
  end

  def create
    @resource = Lieutenant.new(resource_params)
    @resource.role = "regular"
    @resource.ceremonial_county = current_lieutenant.ceremonial_county
    @resource.skip_password_validation = true

    authorize @resource, :create?

    if @resource.save
      redirect_to lieutenant_lieutenants_url,
                  notice: "Lieutenant successfully created"
    else
      render :new
    end
  end

  def update
    authorize @resource, :update?

    if resource_params[:password].present?
      @resource.update(resource_params)
    else
      @resource.update_without_password(resource_params)
    end

    respond_with :lieutenant, @resource, location: lieutenant_lieutenants_path
  end


  def new
    @resource = Lieutenant.new
    authorize @resource, :create?
  end

  def edit
    authorize @resource, :update?
  end


  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :lieutenant, @resource, location: lieutenant_lieutenants_path
  end

  private

  def find_resource
    @resource = current_lieutenant.ceremonial_county.lieutenants.find(params[:id])
  end

  def resource_params
    params.require(:lieutenant).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name,
             :role)
  end
end

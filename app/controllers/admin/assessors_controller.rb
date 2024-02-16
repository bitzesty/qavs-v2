class Admin::AssessorsController < Admin::UsersController
  before_action :permit_search_params, except: [:index]

  def index
    params[:search] ||= AssessorSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :assessor, :index?

    @search = AssessorSearch.new(Assessor.all).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
  end

  def new
    @resource = Assessor.new
    authorize @resource, :create?
  end

  def create
    @resource = Assessor.new(resource_params)
    @resource.skip_password_validation = true

    authorize @resource, :create?

    @resource.save
    location = @resource.persisted? ? admin_assessors_path(search: params[:search], page: params[:page]) : nil
    respond_with :admin, @resource, location: location, notice: "User has been successfully added."
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
                 location: admin_assessors_path(search: params[:search], page: params[:page]),
                 notice: "User has been updated."
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin,
                 @resource,
                 location: admin_assessors_path(search: params[:search], page: params[:page])
  end

  private

  def find_resource
    @resource = Assessor.find(params[:id])
  end

  def resource_params
    params.require(:assessor).
      permit(:email,
             :password,
             :password_confirmation,
             :sub_group,
             :first_name,
             :last_name)
  end

  def permit_search_params
    params[:search].permit! if params[:search].present?
  end
end

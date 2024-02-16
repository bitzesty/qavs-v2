class Admin::GroupLeadersController < Admin::UsersController
  before_action :permit_search_params, except: [:index]

  def index
    params[:search] ||= GroupLeaderSearch::DEFAULT_SEARCH
    params[:search].permit!
    authorize :group_leader, :index?

    @search = GroupLeaderSearch.new(GroupLeader.all).
                             search(params[:search])
    @resources = @search.results.page(params[:page])
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
                 location: admin_group_leaders_path(search: params[:search], page: params[:page]),
                 notice: "User has been successfully updated."
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin,
                 @resource,
                 location: admin_group_leaders_path(search: params[:search], page: params[:page])
  end

  private

  def find_resource
    @resource = GroupLeader.find(params[:id])
  end

  def resource_params
    params.require(:group_leader).
      permit(:email,
             :password,
             :password_confirmation,
             :first_name,
             :last_name)
  end

  def permit_search_params
    params[:search].permit!
  end
end

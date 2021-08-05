class Admin::GroupLeadersController < Admin::UsersController
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
                 location: admin_group_leaders_path,
                 notice: "User has been successfully updated."
  end

  def destroy
    authorize @resource, :destroy?
    @resource.soft_delete!

    respond_with :admin, @resource, location: admin_group_leaders_path
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
end

class GroupLeader::AccountsController < GroupLeader::BaseController
  def edit
    @user = current_group_leader
    authorize @user, :edit?
  end

  def update_password
    @user = current_group_leader
    authorize @user, :update?
    if @user.update_with_password(password_params)
      flash[:success] = 'Your account details were successfully saved'
      bypass_sign_in(@user)
      redirect_to(group_leader_root_path)
    else
      flash.alert = 'Error updating your password'
      @user.reload
      render :edit
    end
  end

  private

  def password_params
    params.require(:group_leader).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end

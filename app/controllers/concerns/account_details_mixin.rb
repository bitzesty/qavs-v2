module AccountDetailsMixin
  def edit
    @user = current_subject
    authorize @user, :update_account_details?
  end

  def update_password
    @user = current_subject
    authorize @user, :update_account_details?
    if @user.update_with_password(password_params)
      flash[:success] = 'Your account details were successfully saved'
      bypass_sign_in(@user)
      redirect_to(send("#{ namespace_name }_root_path"))
    else
      flash.alert = 'Error updating your password'
      @user.reload
      render :edit
    end
  end

  private

  def password_params
    params.require(namespace_name).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end

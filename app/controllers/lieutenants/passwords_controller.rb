class Lieutenants::PasswordsController < Devise::PasswordsController
  after_action :remove_notice

  def remove_notice
    flash[:notice] = nil
  end
end

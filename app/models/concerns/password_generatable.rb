module PasswordGeneratable
  def generate_password!
    # making sure new password is valid
    new_password = Devise.friendly_token.first(20) + ":cS6"

    self.password = new_password
    self.password_confirmation = new_password
  end
end

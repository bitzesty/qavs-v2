module Confirmable
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if resource.encrypted_password.blank?
      token, encoded_token = Devise.token_generator.generate(resource.class, :reset_password_token)
      resource.update(reset_password_token: encoded_token,
                      reset_password_sent_at: Time.current)

      case resource
      when User
        edit_user_password_path(reset_password_token: token)
      when Lieutenant
        edit_lieutenant_password_path(reset_password_token: token)
      when Assessor
        edit_assessor_password_path(reset_password_token: token)
      when Admin
        edit_admin_password_path(reset_password_token: token)
      else
        super(resource_name, resource)
      end
    else
      super(resource_name, resource)
    end
  end
end

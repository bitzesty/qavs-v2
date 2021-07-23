class SessionsController < Devise::SessionsController
  after_action :remove_notice, only: :create

  def create
    actions = _process_action_callbacks.map {|c| c.filter if c.kind == :before }
    actions.each do |action|
      Rails.logger.debug action
    end
    Rails.logger.debug "!!!!!!!!!!!!!!!!"
    Rails.logger.debug auth_options
    Rails.logger.debug['HTTP_COOKIE']
    Rails.logger.debug['warden']
    self.resource = warden.authenticate!(auth_options)
    Rails.logger.debug self.resource
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def remove_notice
    flash[:notice] = nil
  end
end

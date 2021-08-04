class SessionsController < Devise::SessionsController
  after_action :remove_notice, only: :create
  before_action :disable_browser_caching!

  private

  def disable_browser_caching!
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end

  def remove_notice
    flash[:notice] = nil
  end
end

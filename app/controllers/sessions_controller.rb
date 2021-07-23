class SessionsController < Devise::SessionsController
  after_action :remove_notice, only: :create

  def create
    actions = _process_action_callbacks.map {|c| c.filter if c.kind == :before }
    Rails.logger.debug actions
    actions.each do |action|
      Rails.logger.debug action
    end
    super
  end

  private

  def remove_notice
    flash[:notice] = nil
  end
end

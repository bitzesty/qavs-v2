class SessionsController < Devise::SessionsController
  after_action :remove_notice, only: :create

  def create
    actions = _process_action_callbacks.map {|c| {c.filter => c.options} if c.kind == :before }
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

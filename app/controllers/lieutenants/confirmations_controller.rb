# frozen_string_literal: true

class Lieutenants::ConfirmationsController < Devise::ConfirmationsController
  include ::Confirmable
  after_action :remove_notice

  def remove_notice
    flash[:notice] = nil
  end
end

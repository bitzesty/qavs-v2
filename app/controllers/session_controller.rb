class SessionController < ApplicationController
  REFRESHABLES = %w[admin lieutenant judge assessor].freeze

  def refresh
    if REFRESHABLES.include?(params[:scope])
      session["#{params[:scope]}_last_seen_at"] = Time.zone.now
    end

    render json: { ok: true }, status: :ok
  end
end

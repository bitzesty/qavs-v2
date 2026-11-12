class Users::BaseController < ApplicationController
  before_action :authenticate_user!

  # `if:` instead of `only:` so subclasses lacking some of these actions don't raise ActionNotFound
  before_action :restrict_access_if_admin_in_read_only_mode!,
                if: -> { action_name.in?(%w[new create update destroy]) }
end

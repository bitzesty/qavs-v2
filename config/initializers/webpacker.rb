# Configure webpacker to use ASSET_HOST if set
if Rails.env.production?
  # Disable dev server in production - webpacker should use precompiled assets
  Webpacker.config.dev_server[:enabled] = false if Webpacker.config.dev_server

  # Force webpacker to use the asset host from Rails config
  # This ensures webpacker helpers respect ASSET_HOST
  if ENV['ASSET_HOST'].present?
    # Webpacker should automatically use action_controller.asset_host
    # but we ensure it's set correctly
    Rails.application.config.action_controller.asset_host = ENV['ASSET_HOST']
  end
end

Vigilion.configure do |config|
  config.access_key_id = ENV["VIGILION_ACCESS_KEY_ID"] || "Replace me"
  config.secret_access_key = ENV["VIGILION_SECRET_ACCESS_KEY"] || "Replace me"

  # config.server_url = ENV["VIGILION_SERVER_URL"]
  # Integration strategy (default is :url)
  # config.integration = :local

  config.debug = true

  # By default vigilion will be bypassed in development and test environments.
  # Disable vigilion scanning entirely even in production environments:
  # config.loopback = true
  # Enable vigilion scanning even in development and test environments:
  # (Note that the callback URL probably won't be reached)
  config.loopback = ENV["DISABLE_VIRUS_SCANNER"] == "true"
  # Specify different loopback_response (default is 'clean')
  # config.loopback_response = 'infected'
  config.active_job = ENV["VIRUS_SCANNER_ACTIVE_JOB"] == "true"
end

module Vigilion
  class HTTP
    def scan_url(key, url, options = {})
      send scan: options.merge({ key: key, url: url })
    end
  end
end
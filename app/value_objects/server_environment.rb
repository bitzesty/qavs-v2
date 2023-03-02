class ServerEnvironment
  class << self
    def local_or_dev_or_staging_server?
      Rails.env.development? ||
      dev_server? ||
      staging_server?
    end

    def live_server?
      mailer_host_equal_to?("apply.kavs.dcms.gov.uk")
    end

    def staging_server?
      mailer_host_equal_to?("apply-staging.kavs.dcms.gov.uk")
    end

    def dev_server?
      mailer_host_equal_to?("kavs-dev.dcms.gov.uk")
    end

    def env_prefix_in_mailers
      if staging_server?
        "[STAGING]"
      elsif dev_server?
        "[DEV]"
      elsif Rails.env.development?
        "[LOCAL]"
      else
        ""
      end
    end

    private

      def mailer_host_equal_to?(url)
        ENV["MAILER_HOST"].to_s == url
      end
  end
end

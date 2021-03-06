class ApplicationMailer < Mail::Notify::Mailer

  default from: ENV["MAILER_FROM"] || "no-reply@qavs.dcms.gov.uk",
          reply_to: "queensaward@dcms.gov.uk"

  def subject_with_env_prefix(subject_str)
    if ::ServerEnvironment.local_or_dev_or_staging_server?
      "#{::ServerEnvironment.env_prefix_in_mailers} #{subject_str}"
    else
      subject_str
    end
  end
end

class ApplicationMailer < Mail::Notify::Mailer

  default from: ENV["MAILER_FROM"] || "no-reply@queens-awards-enterprise.service.gov.uk",
          reply_to: "queensawards@beis.gov.uk"

  def view_mail(template_id, headers)
    return true if ::CheckAccountOnBouncesEmail.bounces_email?(headers[:to])

    super(template_id, headers)
  end
end

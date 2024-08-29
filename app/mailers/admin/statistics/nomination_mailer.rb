class Admin::Statistics::NominationMailer < ApplicationMailer
  layout "mailer"

  def notify(identifier, file_identifier)
    @admin = Admin.find(identifier)
    @file = @admin.protected_files.find(file_identifier)
    
    subject = "Nomination statistics export - King's Award for Voluntary Service"

    view_mail ENV["GOV_UK_NOTIFY_API_TEMPLATE_ID"], to: @admin.email, subject: subject_with_env_prefix(subject)
  end
end

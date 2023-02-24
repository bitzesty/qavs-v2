class AccountMailers::BaseMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"] || "no-reply@kavs.dcms.gov.uk",
          reply_to: "kingsaward@dcms.gov.uk"

  layout "mailer"

  attr_reader :form_answer
end

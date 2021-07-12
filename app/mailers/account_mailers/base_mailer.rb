class AccountMailers::BaseMailer < ApplicationMailer
  default from: ENV["MAILER_FROM"] || "no-reply@qavs.dcms.gov.uk",
          reply_to: "queensaward@dcms.gov.uk"

  layout "mailer"

  attr_reader :form_answer
end

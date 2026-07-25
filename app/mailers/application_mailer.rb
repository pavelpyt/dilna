class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "dilna@example.com")
  layout "mailer"
end

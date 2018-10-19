class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@jalecitos.com'
  layout 'mailer'

  def mandrill_client
    @mandrill_client ||= Mandrill::API.new ENV.fetch("EMAIL_API_TOKEN")
  end
end

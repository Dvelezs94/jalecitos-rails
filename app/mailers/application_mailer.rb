class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@wandapp.com.mx'
  layout 'mailer'

  def sendgrid_client
    require 'sendgrid-ruby'
    @sendgrid_client = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
  end
end

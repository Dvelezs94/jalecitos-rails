class UserMailer  < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  def sendgrid_client
    require 'sendgrid-ruby'
    @sendgrid_client = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY'))
  end

  def confirmation_instructions(record, token, opts={})
    @token = token
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": record.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": record.alias,
            "CONFIRMURL": confirmation_url(record, confirmation_token: @token)
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "template_id": "d-9e56d320528d4578ae6b1e006ea88edd"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": record.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": record.alias,
            "RESETURL": edit_password_url(record, reset_password_token: @token)
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "template_id": "d-038e9bd99cef4c7ebe128b90e6da69cb"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
    end
end

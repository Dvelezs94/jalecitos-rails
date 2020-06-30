class PayoutMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  def successful_payout(user, amount)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": user.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "ALIAS": user.alias,
            "MONEY": number_to_currency(amount)
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Jalecitos"
      },
      "template_id": "d-80b5e08079de40f79d07b6b73ff538f2"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def failed_payout(user, amount, error)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": user.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "ALIAS": user.alias,
            "MONEY": number_to_currency(amount),
            "ERROR": error
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Jalecitos"
      },
      "template_id": "d-13cee9a591d64ad4826814cd5c4266c7"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def notify_inconsistency(user)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": "soporte@jalecitos.com"
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "ALIAS": user.email
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Jalecitos"
      },
      "template_id": "d-f7072a9372b54565bee54f626cf308df"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

end

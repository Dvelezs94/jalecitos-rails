class PayoutMailer < ApplicationMailer

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
            "MONEY": amount
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
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
            "MONEY": amount,
            "ERROR": error
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-13cee9a591d64ad4826814cd5c4266c7"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

end

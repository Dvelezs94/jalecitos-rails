class ChargesMailer < ApplicationMailer
  def charge_denied(order, error_message)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": order.employer.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": order.employer.alias,
            "ORDER_ID": order.uuid,
            "ERROR_MESSAGE": error_message
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-4ca7e27879db47da876f01e06c708d80"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

class ContactMailer < ApplicationMailer
  def new_message(message, sender, sender_name, phone_number, receiver)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": receiver
            }
          ],
          "dynamic_template_data": {
            "MESSAGE": message,
            "SENDER_MAIL": sender,
            "SENDER_NAME": sender_name,
            "PHONE": phone_number
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "reply_to": {
        "email": sender
      },
      "template_id": "d-356cef85d1ff473b8e7278105b929bba"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

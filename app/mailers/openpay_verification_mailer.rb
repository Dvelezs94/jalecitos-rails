class OpenpayVerificationMailer < ApplicationMailer
  def new_verification(env, code)
    @message = message

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": "diego.velez@jalecitos.com"
            }
          ],
          "dynamic_template_data": {
            "RAILS_ENV": env,
            "VERIFICATION_CODE": code
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "template_id": "d-8438f1c20e4b44f899e06440a116e93e"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

class VerificationMailer < ApplicationMailer
  def approved (verification)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": verification.user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": (verification.user.name || verification.user.alias)
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Jalecitos"
      },
      "template_id": "d-c6af64524cee4e85a0687c9c50da066a"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def denied (verification)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": verification.user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": (verification.user.name || verification.user.alias),
            "DETAILS": (verification.denial_details ||  "Sin informacion extra.")
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Jalecitos"
      },
      "template_id": "d-b6f398e256a3415ba9bb4c3648faa577"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

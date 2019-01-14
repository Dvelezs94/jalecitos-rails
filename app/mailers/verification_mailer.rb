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
            "ALIAS": verification.user.slug
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
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
            "ALIAS": verification.user.slug,
            "DETAILS": verification.denial_details
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-b6f398e256a3415ba9bb4c3648faa577"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

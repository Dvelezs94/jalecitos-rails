class OfferMailer < ApplicationMailer
  def new_offer(offer)
    @offer = offer

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @offer.request.user.email
            }
          ],
          "dynamic_template_data": {
            "REQUEST_URL": request_url(@offer.request),
            "REQUEST": @offer.request.name,
            "OFFERER_URL": user_url(@offer.user.slug),
            "OFFERER": @offer.user.slug,
            "ALIAS": @offer.request.user.slug
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com"
      },
      "template_id": "d-0786709333f0406d86f9eca1fec0bdac"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end

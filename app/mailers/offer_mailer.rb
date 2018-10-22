class OfferMailer < ApplicationMailer
  def new_offer(offer)
    @offer = offer
    template_name = "new-request-offer"
    template_content = []
    message = {
      to: [{email: @offer.request.user.email}],
      subject: "New Offer for #{@offer.request.name}",
      global_merge_vars: [
           { name: "REQUEST_URL", content: user_request_url(@offer.request.user.slug, @offer.request) },
           { name: "REQUEST", content: @offer.request.name },
           { name: "OFFERER_URL", content: user_url(@offer.user.slug) },
           { name: "OFFERER", content: @offer.user.slug },
           { name: "ALIAS", content: @offer.request.user.slug }
          ]
    }
    
    mandrill_client.messages.send_template template_name, template_content, message
  end
end

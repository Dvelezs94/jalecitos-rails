class OfferMailer < ApplicationMailer
  def new_offer(offer)
    @offer = offer
    template_name = "new-request-offer"
    template_content = []
    message = {
      to: [{email: @offer.request.user.email}],
      subject: "New Offer for #{@offer.request.name}",
      global_merge_vars: [
           { name: "REQUEST", content: @offer.request.name },
           { name: "OFFERER", content: @offer.user.alias },
           { name: "ALIAS", content: @offer.request.user.alias }
          ]
    }
    
    mandrill_client.messages.send_template template_name, template_content, message
  end
end

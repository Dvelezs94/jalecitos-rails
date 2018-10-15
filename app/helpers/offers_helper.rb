module OffersHelper
  # Check if User has Already offered
  def has_offered(user_id)
    @request.offers.pluck(:user_id).include? user_id
  end

  def offer_form_url_helper
    if params[:action] == "new"
      user_request_offers_path(@request.user.slug, @request)
    else
      user_request_offer_path(@request.user.slug, @request, @offer)
    end
  end

end

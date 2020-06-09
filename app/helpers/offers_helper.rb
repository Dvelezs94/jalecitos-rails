module OffersHelper
  # Check if User has Already offered
  def has_offered(user_id)
    @request.offers.pluck(:user_id).include? user_id
  end

  def offer_form_url_helper
    if @my_offer.present?
      request_offer_path(params[:id], @my_offer.id)
    else
      request_offers_path(params[:id])
    end
  end

end

module OffersHelper
  # Check if User has Already offered
  def has_offered(user_id)
    @request.offers.pluck(:user_id).include? user_id
  end

  def offer_form_url_helper
    if params[:action] == "new"
      request_offers_path(params[:request_id])
    else
      request_offer_path(params[:request_id], params[:id])
    end
  end

end

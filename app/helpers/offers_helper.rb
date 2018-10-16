module OffersHelper
  # Check if User has Already offered
  def has_offered(user_id)
    @request.offers.pluck(:user_id).include? user_id
  end

  def offer_form_url_helper
    if params[:action] == "new"
      user_request_offers_path(params[:user_id], params[:request_id])
    else
      user_request_offer_path(params[:user_id], params[:request_id], params[:id])
    end
  end

end

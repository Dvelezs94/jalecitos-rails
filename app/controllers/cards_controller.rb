class CardsController < ApplicationController
  include OpenpayHelper
  include RefererFunctions
  before_action :authenticate_user!
  before_action only: [:create, :destroy] do
    init_openpay("card")
  end
  before_action :validate_max_cards, only: :create
  access user: [:create, :destroy]


  def create
    request_hash={
     :token_id => params[:token_id],
     :device_session_id => params[:device_id]
    }
    begin
      @card.create(request_hash, current_user.openpay_id)
      flash[:success] = 'La tarjeta fue creada exitosamente.'
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        flash[:error] = "#{e.description}, por favor intentalo de nuevo."
    end
    
    ref_params = referer_params(request.referer)
    if ref_params["package_id"] != [""] && ref_params["package_id"].present?
      package = Package.find_by_slug(ref_params["package_id"])
      redirect_to hire_user_gig_package_path(package.gig.user, package.gig, package)
    elsif ref_params["offer_id"] != [""] && ref_params["offer_id"].present?
      offer = Offer.find_by_id(ref_params["offer_id"])
      redirect_to hire_request_offer_path(offer.request, offer)
    else
      redirect_to configuration_path(collapse: "payment_methods")
    end
  end

  def destroy
    begin
      @card.delete(params[:id], current_user.openpay_id)
      @success = 'La tarjeta fue borrada exitosamente.'
    rescue OpenpayTransactionException => e
      # @error = "#{e.description}, por favor intentalo de nuevo."
    end
    head :no_content #response with no content
  end

  private
  # Each user can have a max of 3 cards
  def validate_max_cards
    @current_avail_cards = get_openpay_resource("card", current_user.openpay_id).count
    if @current_avail_cards < 3
      return true
    else
      flash[:error] = "Solo puedes tener un maximo de 3 tarjetas. Elimina una para poder proceder."
      redirect_to configuration_path(collapse: "payment_methods")
      return false
    end
  end

end

class CardsController < ApplicationController
  include OpenpayHelper
  include RefererFunctions
  before_action :authenticate_user!
  before_action only: [:create, :destroy] do
    init_openpay("card")
  end
  before_action :validate_max_cards, only: :create
  access user: [:create, :destroy]
  before_action :verify_personal_information, only: :create


  def create
    request_hash={
     :token_id => params[:token_id],
     :device_session_id => params[:device_id]
    }
    begin
      response = @card.create(request_hash, current_user.openpay_id)
      Card.create!(openpay_id: response["id"], user: current_user, cvv: params[:card_cvv])
      flash[:success] = 'La tarjeta fue creada exitosamente.'
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        flash[:error] = "#{e.description}, por favor, intentalo de nuevo."
    rescue
      flash[:error] = "Error al crear la tarjeta, por favor, intentalo de nuevo."
    end

    ref_params = referer_params(request.referer)
    if ref_params["package_id"][0]
      quantity = ref_params["quantity"].blank? ? nil : ref_params["quantity"][0]
      package = Package.find_by_slug(ref_params["package_id"])
      redirect_to hire_package_path(package, quantity: quantity)
    elsif ref_params["offer_id"][0]
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

  def verify_personal_information
    if current_user.name.blank?
      flash[:error] = "Asegúrate de tener tu nombre completo en Jalecitos para proceder a agregar una tarjeta"
      redirect_to configuration_path(bestFocusAfterReload: "change_user_name")
    end
  end

end

class CardsController < ApplicationController
  include OpenpayHelper
  before_action :authenticate_user!
  before_action only: [:create, :destroy] do
    init_openpay("card")
  end
  access user: [:create, :destroy]


  def create
    # address_hash = {
    #   "line1" => card_params[:address_1],
    #   "line2" => card_params[:address_2],
    #   "state" => card_params[:state],
    #   "city" => card_params[:city],
    #   "postal_code" => card_params[:postal_code],
    #   "country_code" => card_params[:country_code],
    # }

    request_hash = {
      :holder_name => card_params[:card_holder_name],
      :card_number => card_params[:card_number],
      :cvv2 => card_params[:cvv2],
      :expiration_month => card_params[:expiration_month],
      :expiration_year => card_params[:expiration_year].last(2),
      # "device_session_id" => card_params[:device_session_id],
      # "address" => address_hash
    }

    begin
      @card.create(request_hash, current_user.openpay_id)
      flash[:success] = 'La tarjeta fue creada exitosamente.'
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        flash[:error] = "#{e.description}, por favor intentalo de nuevo."
    end
    redirect_to user_config_path
  end


  def destroy
    begin
      @card.delete(params[:id], current_user.openpay_id)
      flash[:success] = 'La tarjeta fue borrada exitosamente.'
    rescue OpenpayTransactionException => e
      flash[:error] = "#{e.description}, por favor intentalo de nuevo."
    end
    redirect_to user_config_path
  end

  private
    # Only allow a trusted parameter "white list" through.
    def card_params
        params.permit(:card_holder_name, :card_number, :cvv2,
                                     :expiration_month, :expiration_year)
    end

end

class CardsController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action only: [:create, :destroy] do
    init_openpay("card")
  end
  access user: [:create, :destroy]
  before_action :check_user_ownership, only:[:create, :destroy]


  def create
    address_hash = {
      "line1" => card_params[:address_1],
      "line2" => card_params[:address_2],
      "state" => card_params[:state],
      "city" => card_params[:city],
      "postal_code" => card_params[:postal_code],
      "country_code" => card_params[:country_code],
    }

    request_hash = {
      "holder_name" => card_params[:holder_name],
      "card_number" => card_params[:card_number],
      "cvv2" => card_params[:cvv2],
      "expiration_month" => card_params[:expiration_month],
      "expiration_year" => card_params[:expiration_year],
      "device_session_id" => card_params[:device_session_id],
      "address" => address_hash
    }

    begin
      @card.create(request_hash.to_hash, current_user.openpay_id)
      flash[:success] = 'La tarjeta fue creada exitosamente.'
      redirect_to user_config_path
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        flash[:error] = "#{e.description}, por favor intentalo de nuevo."
        redirect_to user_config_path
    end
  end


  def destroy
    begin
      @card.delete(params[:id], current_user.openpay_id)
      flash[:success] = 'La tarjeta fue borrada exitosamente.'
      redirect_to user_config_path
    rescue OpenpayTransactionException => e
      flash[:error] = "#{e.description}, por favor intentalo de nuevo."
      redirect_to user_config_path
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def card_params
        params.permit(:holder_name, :card_number, :cvv2, :device_session_id,
                                     :expiration_month, :expiration_year,
                                     :address_1, :address_2, :state, :city, :postal_code, :country_code)
    end

    def set_user
      @user = current_user
    end

    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end

end

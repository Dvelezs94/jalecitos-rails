class CardsController < ApplicationController
  #include OpenpayHelper
  include UsersHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  access user: [:create, :destroy]
  before_action :check_user_ownership, only:[:create, :destroy]


  def create
    begin
      customer = Conekta::Customer.find(current_user.conekta_id)
      source  = customer.create_payment_source(type: "card", token_id: params[:conektaTokenId])
      flash[:success] = 'La tarjeta fue creada exitosamente.'
      redirect_to user_config_path
    rescue => e
        flash[:error] = "#{e.message_to_purchaser}, por favor intentalo de nuevo."
        redirect_to user_config_path
    end
  end


  def destroy
    begin
      customer = Conekta::Customer.find(current_user.conekta_id)
      source  = customer.payment_sources[params[:id].to_i].delete
      flash[:success] = 'La tarjeta fue borrada exitosamente.'
      redirect_to user_config_path
    rescue => e
      flash[:error] = "#{e.message}, por favor intentalo de nuevo."
      redirect_to user_config_path
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def card_params
        params.permit(:card_holder_name, :card_number, :cvv2, :device_session_id,
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

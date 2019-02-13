class CardsController < ApplicationController
  include OpenpayHelper
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
    redirect_to "#{configuration_path}#card"
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
      redirect_to "#{configuration_path}#card"
      return false
    end
  end

end

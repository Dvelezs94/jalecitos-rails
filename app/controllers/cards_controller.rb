class CardsController < ApplicationController
  include OpenpayHelper
  before_action :authenticate_user!
  before_action only: [:create, :destroy] do
    init_openpay("card")
  end
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

end

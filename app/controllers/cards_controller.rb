class CardsController < ApplicationController
  #include OpenpayHelper
  before_action :authenticate_user!
  access user: [:create, :destroy]


  def create
    begin
      customer = Conekta::Customer.find(current_user.conekta_id)
      source  = customer.create_payment_source(type: "card", token_id: card_token)
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
       customer.payment_sources.each_with_index do |card, n|
         #if is the card to erase and is the owner of it...
         if card[1].id == params[:id] && card[1].parent_id == current_user.conekta_id
           #try to delete
            source  = customer.payment_sources[n].delete
            flash[:success] = 'La tarjeta fue borrada exitosamente.'
         end
       end
    rescue => e
      flash[:error] = "#{e.message}, por favor intentalo de nuevo."
    end
    redirect_to user_config_path
  end

  private
    # Only allow a trusted parameter "white list" through.
    def card_token
        params.permit(:conektaTokenId)[:conektaTokenId]
    end

end

class OrdersController < ApplicationController
  before_action :authenticate_user!
  access user: :all
  before_action only: [:create, :close] do
    init_openpay("charge")
  end
  before_action :check_user_ownership, only:[:create, :destroy]

  def create
    @order = Order.new(sanitized_params(order_params))

    request_hash = {
      "method" => "card",
      "source_id" => order_params[:card],
      "amount" => order_params[:total],
      "currency" => "MXN",
      "description" => "Buy #{@order.purchase_type} #{@order.purchase.name}",
      "device_session_id" => params[:device_session_id]
    }

    if @order.save
      begin
        @charge.create(request_hash, current_user.openpay_id)
        create_notification(order.user, order.purchase.user, "compro", order.purchase)
        flash[:success] = 'La tarjeta fue creada exitosamente.'
        redirect_to user_config_path
      rescue OpenpayTransactionException => e
          # e.http_code
          # e.error_code
          flash[:error] = "#{e.description}, por favor intentalo de nuevo."
          redirect_to user_config_path
      end
    else
      puts "test de orden fallida"
    end

  end

  def close

  end

  def show

  end

  private

    # Only allow a trusted parameter "white list" through.
    def order_params
      order_params = params.require(:order).permit(:purchase, :card)
      order_params = set_owner(order_params)
    end

    def set_owner parameters
      parameters[:user_id] = current_user.id
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end
end

class OrdersController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  before_action :authenticate_user!
  access user: :all
  before_action only: [:create, :close] do
    init_openpay("charge")
  end
#  before_action :check_user_ownership, only:[:create, :destroy]

  def create
    @order = Order.new(order_params)

    request_hash = {
      "method" => "card",
      "source_id" => order_params[:card_id],
      "amount" => @order.purchase.price,
      "currency" => "MXN",
      "description" => "Compraste #{@order.purchase_type} #{@order.purchase.name} por la cantidad de #{@order.purchase.price}",
      "device_session_id" => "params[:device_session_id]"
    }

    if @order.save
      begin
        response = @charge.create(request_hash, current_user.openpay_id)
        create_notification(@order.user, @order.purchase.gig.user, "te contrato", @order.purchase)
        flash[:success] = 'La orden fue creada exitosamente.'
        redirect_to root_path
      rescue OpenpayTransactionException => e
          flash[:error] = "#{e.description}, por favor intentalo de nuevo."
          redirect_to root_path
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
      order_params = params.require(:order).permit(:card_id, :purchase)
      order_params = set_defaults(order_params)
    end

    def set_defaults parameters
      parameters[:user_id] = current_user.id
      parameters[:purchase] = Package.friendly.find(params[:order][:purchase])
      parameters
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end
end

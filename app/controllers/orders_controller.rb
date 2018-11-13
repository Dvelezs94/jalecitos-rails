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
        @order.response_order_id = response["id"]
        @order.save
        create_notification(@order.user, @order.purchase.gig.user, "te contrato", @order.purchase)
        flash[:success] = 'La orden fue creada exitosamente.'
        redirect_to purchases_path
      rescue OpenpayTransactionException => e
          flash[:error] = "#{e.description}, por favor intentalo de nuevo."
          redirect_to purchases_path
      end
    else
      puts "test de orden fallida"
    end

  end

  def start
    @order = Order.find(params[:id])
    
    if @order.code == params[:code].to_i
      @order.in_progress!
      flash[:success] = "La orden se actualizo correctamente"
      redirect_to sales_path
    else
      flash[:error] = "Codigo incorrecto, intenta de nuevo con el codigo correcto"
      redirect_to sales_path
    end

  end

  def complete
  end


  def refund
  end

  private

    # Only allow a trusted parameter "white list" through.
    def order_params
      order_params = params.require(:order).permit(:card_id, :purchase)
      order_params = set_defaults(order_params)
    end

    def set_defaults parameters
      pack = Package.friendly.find(params[:order][:purchase])
      parameters[:user_id] = current_user.id
      parameters[:receiver] = pack.gig.user_id
      parameters[:purchase] = pack
      parameters[:total] = pack.price
      parameters[:code] = rand 10000..99999
      parameters
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end
end

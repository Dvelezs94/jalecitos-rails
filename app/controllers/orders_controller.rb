class OrdersController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  before_action :authenticate_user!
  access user: :all
  before_action only: [:create, :close] do
    init_openpay("charge")
  end
  before_action :get_order, only: [:request_start, :start]
  before_action :check_receiver, only: :request_start
  before_action :check_owner, only: :start
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
        create_notification(@order.user, @order.receiver, "te contrato", @order.purchase)
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

  def request_start
    @order.started_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    if @order.save
      flash[:success] = "La orden se actualizo correctamente"
      create_notification(@order.receiver, @order.user, "solicito comenzar", @order.purchase)
      redirect_to sales_path
    else
      flash[:error] = "Hubo un error en tu  solicitud"
      redirect_to sales_path
    end
  end

  def start
    if @order.in_progress!
      flash[:success] = "La orden ahora esta en progreso"
      create_notification(@order.user, @order.receiver, "ha comenzado", @order.purchase)
      redirect_to purchases_path
    else
      flash[:error] = "Hubo un error en tu solicitud"
      redirect_to purchases_path
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
      parameters[:receiver_id] = pack.gig.user_id
      parameters[:purchase] = pack
      parameters[:total] = pack.price
      parameters
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end

    def get_order
      @order = Order.find(params[:id])
    end

    def check_receiver
      if @order.receiver != current_user
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end
    def check_owner
      if @order.user != current_user
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end
end

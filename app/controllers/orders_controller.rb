class OrdersController < ApplicationController
  before_action :authenticate_user!
  include OpenpayHelper
  include UsersHelper
  access user: :all
  before_action only: [:create] do
    init_openpay("charge")
  end
  before_action :get_order, only: [:request_start, :start, :request_complete, :complete, :refund]
  before_action :verify_order_receiver, only: [:request_start, :request_complete]
  before_action :verify_order_owner, only: [:start, :complete]
  before_action :verify_owner_or_receiver, only: [:refund]
  before_action :verify_charge_response, except: [:create]


  def create
    @order = Order.new(order_params)

    # Validate if Gig is own, banned or draft
    if @order.purchase.gig
      @gig = @order.purchase.gig
      if @gig.draft? || @gig.banned?
        flash[:error] = "Este jale no esta disponible"
        redirect_to root_path
        return
      end
    end

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
        redirect_to finance_path(:table => "purchases")
      rescue OpenpayTransactionException => e
        @order.denied!
        flash[:error] = "#{e.description}, por favor intentalo de nuevo."
        redirect_to finance_path(:table => "purchases")
      end
    else
      puts "Orden fallida"
      p @order
    end

  end

  def request_start
    @order.started_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    if @order.save
      flash[:success] = "La orden se actualizo correctamente"
      create_notification(@order.receiver, @order.user, "solicito comenzar", @order.purchase)
      redirect_to finance_path(:table => "sales")
    else
      flash[:error] = "Hubo un error en tu  solicitud"
      redirect_to finance_path(:table => "sales")
    end
  end

  def request_complete
    @order.completed_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    if @order.save
      flash[:success] = "La orden se actualizo correctamente"
      create_notification(@order.receiver, @order.user, "solicito finalizar", @order.purchase)
      redirect_to finance_path(:table => "sales")
    else
      flash[:error] = "Hubo un error en tu  solicitud"
      redirect_to finance_path(:table => "sales")
    end
  end

  def start
    if @order.in_progress!
      flash[:success] = "La orden ahora esta en progreso"
      create_notification(@order.user, @order.receiver, "ha comenzado", @order.purchase)
      redirect_to finance_path(:table => "purchases")
    else
      flash[:error] = "Hubo un error en tu solicitud"
      redirect_to finance_path(:table => "purchases")
    end
  end

  def complete
    if @order.completed!
      @user = @order.receiver
      if @user.save
        create_notification(@order.user, @order.receiver, "te ha depositado", @user)
      else
        create_notification(@order.user, @order.receiver, "algo salio mal depositando", @user)
      end
      flash[:success] = "La orden ahora esta finalizada"
      create_notification(@order.user, @order.receiver, "ha finalizado", @order.purchase)
      redirect_to finance_path(:table => "purchases")
    else
      flash[:error] = "Hubo un error en tu solicitud"
      redirect_to finance_path(:table => "purchases")
    end
  end


  def refund
    if @order.completed? || @order.disputed?
      flash[:error] = "No se pueden reembolsar ordenes completadas o en disputa"
      redirect_to finance_path(:table => "purchases")
      return
    elsif @order.refunded?
      flash[:error] = "Esta orden ya fue reembolsada"
      redirect_to finance_path(:table => "purchases")
      return
    else
      if @order.in_progress? && (current_user == @order.user)
        flash[:error] = "Esta accion no esta permitida"
        redirect_to finance_path(:table => "purchases")
        return
      end
      @user = @order.user
      if @user.save && @order.refunded!
        create_notification(@order.user, @order.user, "ha reembolsado", @order.purchase)
        flash[:success] = "La compra ha sido reembolsada y el dinero sumado a la cuenta"
        redirect_to user_config_path(current_user)
      else
        flash[:error] = "Algo salio mal reembolsando la orden"
        redirect_to finance_path(:table => "purchases")
      end
    end
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

    def verify_order_receiver
      if @order.receiver != current_user
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end

    def verify_order_owner
      if @order.user != current_user
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end

    def verify_owner_or_receiver
      if ! (@order.user != current_user ||  @order.receiver != current_user)
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end

    def verify_charge_response
      if @order.response_order_id.nil?
        flash[:error] = "Esta orden no a sido procesada, y por lo tanto no puede ser empezada"
        redirect_to root_path
      end
    end
end

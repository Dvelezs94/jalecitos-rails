class OrdersController < ApplicationController
  before_action :authenticate_user!
  include OpenpayHelper
  include UsersHelper
  access user: :all
  before_action only: [:create] do
    init_openpay("charge")
  end
  before_action :get_order, only: [:request_start, :start, :request_complete, :complete, :refund]
  before_action :verify_order_employee, only: [:request_start, :request_complete]
  before_action :verify_order_owner, only: [:start, :complete]
  before_action :verify_owner_or_employee, only: [:refund]
  before_action :verify_charge_response, except: [:create]
  before_action :verify_order_limit, only: [:create]


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
        create_notification(@order.user, @order.employee, "te contrato", @order.purchase, "sales")
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
    if @order.employee == current_user
      @order.started_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      if @order.employee == current_user
        if @order.save
          flash[:success] = "La orden se actualizo correctamente"
          create_notification(@order.employee, @order.user, "solicito comenzar", @order.purchase, "purchases")
          redirect_to finance_path(:table => "sales")
        else
          flash[:error] = "Hubo un error en tu  solicitud"
          redirect_to finance_path(:table => "sales")
        end
      end
    end
  end

  def request_complete
    if @order.employee == current_user
      @order.completed_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      if @order.save
        flash[:success] = "La orden se actualizo correctamente"
        create_notification(@order.employee, @order.user, "solicito finalizar", @order.purchase, "purchases")
        redirect_to finance_path(:table => "sales")
      else
        flash[:error] = "Hubo un error en tu  solicitud"
        redirect_to finance_path(:table => "sales")
      end
    end
  end

  def start
    if @order.user == current_user
      if @order.in_progress!
        flash[:success] = "La orden ahora esta en progreso"
        create_notification(@order.user, @order.employee, "ha comenzado", @order.purchase, "sales")
        redirect_to finance_path(:table => "purchases")
      else
        flash[:error] = "Hubo un error en tu solicitud"
        redirect_to finance_path(:table => "purchases")
      end
    end
  end

  def complete
    if @order.user == current_user || current_user.has_roles?(:admin)
      if @order.in_progress? || @order.disputed?
        if @order.completed!
          if @order.dispute
            @order.dispute.proceeded!
          end
          # add 1 to gig order count
          if @order.purchase_type == "Package"
            @order.purchase.gig.increment!(:order_count)
          end
          flash[:success] = "La orden ahora esta finalizada"
          create_notification(@order.user, @order.employee, "ha finalizado", @order.purchase, "sales")
          redirect_to finance_path(:table => "purchases")
        else
          flash[:error] = "Hubo un error en tu solicitud"
          redirect_to finance_path(:table => "purchases")
        end
      end
    end
  end


  def refund
    # check if is not admin
    if ! current_user.has_roles?(:admin)
      # Cancel transaction if the order is on any of these states
      cancel_state(["completed", "disputed", "refunded"])
      if @order.in_progress? && (current_user == @order.user)
        cancel_state(["in_progress"])
      end
    else
      cancel_state(["completed", "refunded"])
    end
    if flash[:error]
      redirect_to root_path
      return
    end
    @user = @order.user
    if @user.save && @order.refunded!
      if @order.dispute
        @order.dispute.refunded!
      end
      create_notification(@order.user, @order.user, "ha reembolsado", @order.purchase, "purchases")
      flash[:success] = "La compra ha sido reembolsada y el dinero sumado a la cuenta"
      redirect_to user_config_path(current_user)
    else
      flash[:error] = "Algo salio mal reembolsando la orden"
      redirect_to finance_path(:table => "purchases")
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
      parameters[:employee_id] = pack.gig.user_id
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

    def verify_order_employee
      if @order.employee != current_user
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end

    def verify_order_owner
      if @order.user != current_user && ! current_user.has_role?(:admin)
        flash[:error] = "No tienes permiso para acceder aqui"
        redirect_to root_path
        return
      end
    end

    def verify_owner_or_employee
      if ! (@order.user != current_user ||  @order.employee != current_user)
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

    def cancel_state(state)
      state.each do |s|
        if @order.status == s
          flash[:error] = "No se puede completar la transaccion"
          break
        end
      end
    end

    def verify_order_limit
      if current_user.purchases.pending.count >= 5
        flash[:error] = "No puedes tener mas de 5 jales pendientes"
        redirect_to finance_path(:table => "purchases")
      end
    end
end

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
  before_action :verify_availability, only: [:create]
  before_action :verify_order_limit, only: [:create]
  before_action :verify_refund_state, only: [:refund]


  def create
    @order = Order.new(order_params)
    #prepare charge
    request_hash = {
      "method" => "card",
      "source_id" => order_params[:card_id],
      "amount" => @order.purchase.price,
      "currency" => "MXN",
      "description" => "Compraste #{@order.purchase_type} #{@order.purchase.name} por la cantidad de #{@order.purchase.price}",
      "device_session_id" => "params[:device_session_id]"
    }

    if @order.save
      #create charge on openpay
      begin
        response = @charge.create(request_hash, current_user.openpay_id)
        @order.response_order_id = response["id"]
        @order.save
        create_notification(@order.employer, @order.employee, "te contrató", @order.purchase, "sales")
        flash[:success] = 'La orden fue creada exitosamente.'
      rescue OpenpayTransactionException => e
        @order.denied!
        flash[:error] = "#{e.description}, por favor, inténtalo de nuevo."
      end
    end
    redirect_to finance_path(:table => "purchases")
  end #create end

  def request_start
      @order.started_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      if @order.employee == current_user
        if @order.save
          flash[:success] = "La orden se actualizó correctamente"
          create_notification(@order.employee, @order.employer, "solicitó comenzar", @order.purchase, "purchases")
        else
          flash[:error] = "Hubo un error en tu  solicitud"
        end
        redirect_to finance_path(:table => "sales")
      end
  end

  def request_complete
      @order.completed_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      if @order.save
        flash[:success] = "La orden se actualizó correctamente"
        create_notification(@order.employee, @order.employer, "solicitó finalizar", @order.purchase, "purchases")
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
      redirect_to finance_path(:table => "sales")
  end

  def start
      if @order.in_progress!
        flash[:success] = "La orden está en progreso"
        create_notification(@order.employer, @order.employee, "ha comenzado", @order.purchase, "sales")
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
      redirect_to finance_path(:table => "purchases")
  end

  def complete
    #if the order is disputed just the admin can complete it
    if @order.in_progress? ||( @order.disputed? && current_user.has_roles?(:admin) )
      if @order.completed!
        if @order.dispute
          @order.dispute.proceeded!
        end
          # add 1 to gig order count
        if @order.purchase_type == "Package"
          @order.purchase.gig.increment!(:order_count)
        end
        flash[:success] = "La orden ha finalizado"
        # Create Reviews for employer and employee with gig or request
        if @order.purchase_type == "Package"
          create_reviews(@order.purchase.gig, @order, @order.employer)
          create_reviews(@order.purchase.gig, @order, @order.employee)
        else
          create_reviews(@order.purchase.request, @order, @order.employer)
          create_reviews(@order.purchase.request, @order, @order.employee)
        end

        create_notification(@order.employer, @order.employee, "ha finalizado", @order.purchase, "sales")
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
    else
      flash[:error] = "Hubo un error en tu solicitud"
    end
      redirect_to finance_path(:table => "purchases", :review => true)
  end


  def refund
    #try to refund...
    if  @order.refunded!
      #if the order has a dispute (and obviously is disputed...)
      if @order.dispute
        #change dispute status to refunded
        @order.dispute.refunded!
      end
      create_notification(@order.employer, @order.employer, "ha reembolsado", @order.purchase, "purchases")
      flash[:success] = "La compra ha sido reembolsada y el dinero sumado a la cuenta"
    else
      flash[:error] = "Algo salió mal reembolsando la orden"
    end
    redirect_to finance_path(:table => "purchases")
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
        flash[:error] = "No tienes permisos para acceder aquí"
        redirect_to root_path
      end
    end

    def get_order
      @order = Order.find(params[:id])
    end

    def verify_order_employee
      if @order.employee != current_user
        flash[:error] = "No tienes permiso para acceder aquí"
        redirect_to root_path
        return
      end
    end

    def verify_order_owner
      if @order.employer != current_user && ! current_user.has_role?(:admin)
        flash[:error] = "No tienes permiso para acceder aquí"
        redirect_to root_path
        return
      end
    end

    def verify_owner_or_employee
      if ! (@order.employer != current_user ||  @order.employee != current_user)
        flash[:error] = "No tienes permiso para acceder aquí"
        redirect_to root_path
        return
      end
    end

    def verify_charge_response
      if @order.response_order_id.nil?
        flash[:error] = "Esta orden no ha sido procesada y por lo tanto no puede comenzar"
        redirect_to root_path
      end
    end

    def cancel_state(state)
      state.each do |s|
        if @order.status == s
          flash[:error] = "No se puede completar la transacción"
          break
        end
      end
    end

    def verify_order_limit
      if current_user.purchases.pending.count >= 5
        flash[:error] = "No puedes tener más de 5 jales pendientes"
        redirect_to finance_path(:table => "purchases")
      end
    end

    def verify_refund_state
      # check if is not admin
      if ! current_user.has_roles?(:admin)
        # Cancel transaction if the order is on any of these states
        cancel_state(["completed", "disputed", "refunded"])
        #employer cant refund orders in progress
        if @order.in_progress? && (current_user == @order.employer)
          cancel_state(["in_progress"])
        end
      #if i am the admin...
      else
        cancel_state(["completed", "refunded"])
      end
      #if something is wrong
      if flash[:error]
        redirect_to root_path
        return
      end
    end

    def verify_availability
      # Validate if Gig is own, banned or draft
      @package = Package.includes(gig: :user).friendly.find(params[:order][:purchase])
        if (@package.gig.user == current_user || @package.gig.draft? || @package.gig.banned?)
          flash[:error] = "Este jale no está disponible"
          redirect_to root_path
          return
        end
    end

    def create_reviews(model, order, giver)
      Review.create(reviewable: model, order: order, giver: giver)
    end
end

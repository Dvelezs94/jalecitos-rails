class OrdersController < ApplicationController
  before_action :authenticate_user!
  include OpenpayHelper
  include UsersHelper
  include ApplicationHelper
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
  before_action :check_billing_profile, only: :create

  def create
    @order = Order.new(order_params)
    # Add IVA
    @order.total = (@order.total * 1.16).round(2) if @order.billing_profile_id

    #prepare charge
    request_hash = {
      "method" => "card",
      "source_id" => order_params[:card_id],
      "amount" => @order.total,
      "currency" => "MXN",
      "description" => "Compraste #{@order.purchase_type} con el id: #{@order.purchase.id}, por la cantidad de #{@order.total}",
      "device_session_id" => "params[:device_session_id]"
    }

    if @order.save
      #create charge on openpay
      begin
        response = @charge.create(request_hash, current_user.openpay_id)
        @order.response_order_id = response["id"]
        @order.save
        if @order.purchase_type == "Offer"
          @order.purchase.request.update(employee: @order.purchase.user)
          @order.purchase.request.in_progress!
          OrderMailer.new_request_order_to_employee(@order).deliver
          OrderMailer.new_request_order_to_employer(@order).deliver
        else
          OrderMailer.new_gig_order_to_employee(@order).deliver
          OrderMailer.new_gig_order_to_employer(@order).deliver
        end
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
        elsif @order.purchase_type == "Offer"
          @order.purchase.request.completed!
        end
        # Generate invoice if requested and if order changed to completed state
        OrderInvoiceGeneratorJob.perform_later(@order) if @order.billing_profile_id
        flash[:success] = "La orden ha finalizado"
        # Create Reviews for employer and employee with gig or request
        create_reviews
        create_notification(@order.employer, @order.employee, "ha finalizado", @order.purchase, "sales", @other_review.id)
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
    else
      flash[:error] = "Hubo un error en tu solicitud"
    end
      redirect_to finance_path(:table => "purchases", :review => true, :identifier => @my_review.id)
  end


  def refund
    #try to refund...
    if  @order.refunded!
      #if the order has a dispute (and obviously is disputed...)
      if @order.dispute
        #change dispute status to refunded
        @order.dispute.refunded!
      end
      if @order.purchase_type == "Offer"
        @order.purchase.request.closed!
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
      order_params = params.require(:order).permit(:card_id, :purchase, :purchase_type, :billing_profile_id)
      order_params = set_defaults(order_params)
    end

    def set_defaults parameters
      if parameters[:purchase_type] == "Package"
        pack = Package.friendly.find(params[:order][:purchase])
        parameters[:employee_id] = pack.gig.user_id
      elsif parameters[:purchase_type] == "Offer"
        pack = Offer.find(params[:order][:purchase])
        parameters[:employee_id] = pack.user_id
      end
        parameters[:user_id] = current_user.id
        parameters[:purchase] = pack
        parameters[:total] = cons_mult_helper(pack.price).round(2)
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
      if params[:order][:purchase_type] == "Package"
        @package = Package.includes(gig: :user).friendly.find(params[:order][:purchase])
        if (@package.gig.user == current_user || @package.gig.draft? || @package.gig.banned?)
          cancel_execution
        end
      elsif params[:order][:purchase_type] == "Offer"
        @offer = Offer.includes(request: :user).find(params[:order][:purchase])
        if (@offer.request.user != current_user || @offer.request.banned? )
          cancel_execution
        end
      else
        cancel_execution
      end
    end

    def cancel_execution
      flash[:error] = "Este jale no está disponible"
      redirect_to root_path
      return
    end

    def create_reviews
      #this is useful for collecting the two reviews generated
      @new_reviews = []
      if @order.purchase_type == "Package"
        #useful when i want to obtain reviews of gig
        create_review( @order, @order.employer, @order.purchase.gig)
        create_review( @order, @order.employee)
      else
        create_review(@order, @order.employer)
        create_review(@order, @order.employee)
      end
      #get the id of the user corresponding review and the one for use in the job
      @my_review = @new_reviews.select{ |r| r.giver_id == current_user.id }.first
      @other_review = @new_reviews.select{ |r| r.giver_id != current_user.id }.first
    end

    def create_review(order, giver, gig=nil)
      @new_reviews << Review.create( order: order, giver: giver, gig: gig)
    end

    # Make sure the billing profile is legit
    def check_billing_profile
      if order_params[:billing_profile_id] != nil
        (current_user.billing_profiles.find_by_status("enabled").id != order_params[:billing_profile_id].to_i) ? cancel_execution : nil
      end
    end
end

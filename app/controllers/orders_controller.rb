class OrdersController < ApplicationController
  before_action :authenticate_user!
  include OpenpayHelper
  include UsersHelper
  include ApplicationHelper
  access user: :all
  before_action only: [:create, :refund] do
    init_openpay("charge")
  end
  before_action only: [:create, :complete, :refund] do
    init_openpay("transfer")
  end
  before_action only: [:complete] do
    init_openpay("fee")
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

    #prepare charge
    request_hash = {
      "method" => "card",
      "source_id" => order_params[:card_id],
      "amount" => purchase_order_total(@order.total),
      "currency" => "MXN",
      "description" => "Compraste #{@order.purchase_type} con el id: #{@order.purchase.id}, por la cantidad de #{purchase_order_total(@order.total)}",
      "device_session_id" => params[:device_id],
      "use_3d_secure" => true,
      "redirect_url" => finance_url(:table => "purchases")
    }

    if @order.save
      #create charge on openpay
      begin
        response = @charge.create(request_hash, current_user.openpay_id)
        @order.response_order_id = response["id"]
        @order.save
        redirect_to response["payment_method"]["url"]
      rescue OpenpayTransactionException => e
        @order.denied!
        flash[:error] = "#{e.description}, por favor, inténtalo de nuevo."
        redirect_to finance_path(:table => "purchases")
      end
    end

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
      #Openpay call to transfer the fee to the Employee
      request_hash = {
        "customer_id" => @order.employee.openpay_id,
        "amount" => get_order_earning(@order.purchase.price),
        "description" => "Pago de orden #{@order.uuid} por la cantidad de #{get_order_earning(@order.purchase.price)}",
        "order_id" => "#{@order.uuid}-complete"
      }
      begin
        response = @transfer.create(request_hash, ENV.fetch("OPENPAY_HOLD_CLIENT"))
        @order.response_completion_id = response["id"]
        @order.save
      rescue OpenpayTransactionException => e
        flash[:error] = "#{e}"
        redirect_to finance_path(:table => "purchases")
        return false
      end
      # End openpay call
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
        #Charge the fee
        charge_fee(@order, @fee)
        #charge tax
        charge_tax(@order, @fee)
        # Generate invoice if requested and if order changed to completed state
        OrderInvoiceGeneratorWorker.perform_async(@order.id) if @order.billing_profile_id
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
    # Move money from hold account to employer account
    request_transfer_hash_hold = {
      "customer_id" => @order.employer.openpay_id,
      "amount" => purchase_order_total(@order.total),
      "description" => "reembolso de orden #{@order.uuid} por la cantidad de #{purchase_order_total(@order.total)}",
      "order_id" => "#{@order.uuid}-refund"
    }
    begin
      response = @transfer.create(request_transfer_hash_hold, ENV.fetch("OPENPAY_HOLD_CLIENT"))
      @order.response_refund_id = response["id"]
      @order.save
    rescue OpenpayTransactionException => e
      flash[:error] = "#{e}"
      redirect_to finance_path(:table => "purchases")
      return false
    end
    # Refund money to card from employer openpay account
    request_hash = {
      "description" => "Monto de la orden #{@order.uuid} devuelto por la cantidad de #{purchase_order_total(@order.total)}",
      "amount" => purchase_order_total(@order.total)
    }
    begin
      response = @charge.refund(@order.response_order_id ,request_hash, @order.employer.openpay_id)
      @order.response_refund_id = response["id"]
      @order.save
    rescue OpenpayException => e
      flash[:error] = "#{e}"
      redirect_to finance_path(:table => "purchases")
      return false
    end
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
      if current_user == @order.employer
        flash[:success] = "La compra ha sido reembolsada, ten en cuenta que puede tardar hasta 72 hrs para aparecer en tu cuenta bancaria"
      else
        create_notification(@order.employee, @order.employer, "te ha reembolsado", @order, "purchases")
      end
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
        parameters[:employer_id] = current_user.id
        parameters[:purchase] = pack
        parameters[:total] = purchase_order_total(pack.price).round(2)
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
        create_review( @order, @order.employer, @order.employee, @order.purchase.gig)
        create_review( @order, @order.employee, @order.employer, @order.purchase.gig)
      else
        create_review(@order, @order.employer, @order.employee, @order.purchase.request)
        create_review(@order, @order.employee, @order.employer, @order.purchase.request)
      end
      #get the id of the user corresponding review and the one for use in the job
      @my_review = @new_reviews.select{ |r| r.giver_id == current_user.id }.first
      @other_review = @new_reviews.select{ |r| r.giver_id != current_user.id }.first
    end

    def create_review(order, giver, receiver, object)
      @new_reviews << Review.create( order: order, giver: giver, receiver: receiver, reviewable: object)
    end

    # Make sure the billing profile is legit
    def check_billing_profile
      if order_params[:billing_profile_id] != nil
        cancel_execution if (current_user.billing_profiles.find_by_status("enabled").id != order_params[:billing_profile_id].to_i)
      end
    end

    def charge_fee(order, fee)
      request_fee_hash={"customer_id" => ENV.fetch("OPENPAY_HOLD_CLIENT"),
                     "amount" => get_order_fee(order.purchase.price),
                     "description" => "Cobro de Comisión por la orden #{order.uuid}",
                     "order_id" => "#{order.uuid}-fee"
                    }
      begin
        response_fee = fee.create(request_fee_hash)
        order.response_fee_id = response_fee["id"]
        order.save
      rescue
        order.response_fee_id = "failed"
        order.save
      end
    end

    def charge_tax(order, fee)
      request_tax_hash={"customer_id" => ENV.fetch("OPENPAY_HOLD_CLIENT"),
                     "amount" => order_tax(order.purchase.price),
                     "description" => "Cobro de impuesto por la orden #{order.uuid}",
                     "order_id" => "#{order.uuid}-tax"
                    }
      begin
        response_tax = fee.create(request_tax_hash)
        order.response_tax_id = response_tax["id"]
        order.save
      rescue
        order.response_tax_id = "failed"
        order.save
      end
    end
end

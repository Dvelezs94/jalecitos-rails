class OrdersController < ApplicationController
  before_action :authenticate_user!
  include SetLayout
  include OpenpayHelper
  include OpenpayFunctions
  include UsersHelper
  include ApplicationHelper
  include OrderFunctions
  layout :set_layout
  access user: :all, admin: [:complete, :refund]
  before_action only: [:create, :refund] do
    init_openpay("charge")
  end
  before_action only: [:create, :complete, :refund] do
    init_openpay("transfer")
  end
  before_action only: [:complete] do
    init_openpay("fee")
  end
  before_action :get_order_by_uuid, only: [:request_start, :start, :request_complete, :complete, :refund, :details, :update_details]
  before_action :verify_order_employee, only: [:request_start, :request_complete]
  before_action :verify_order_owner, only: [:start, :complete, :details, :update_details]
  before_action :verify_owner_or_employee, only: [:refund]
  before_action :verify_charge_response, except: [:create]
  before_action :verify_availability, only: [:create]
  before_action :verify_order_limit, only: [:create]
  before_action :verify_refund_state, only: [:refund]
  before_action :check_billing_profile, only: :create

  def create
    @order = Order.new(order_params)
    if @order.save
      # minimum amount to require 3d secure
      min_3d_amount = 2999
      #prepare charge
      request_hash = {
        "method" => "card",
        "source_id" => order_params[:card_id],
        "amount" => @order.total,
        "currency" => "MXN",
        "description" => "Compraste #{@order.purchase_type} con el id: #{@order.purchase.id}, por la cantidad de #{@order.total}",
        "device_session_id" => params[:device_id],
        "use_3d_secure" => (@order.total > min_3d_amount) ? true : false,
        "redirect_url" => details_order_url(@order.uuid)
      }
      #create charge on openpay
      begin
        response = @charge.create(request_hash, current_user.openpay_id)
        @order.response_order_id = response["id"]
        @order.save
        flash[:success] = "Se ha creado la orden."
        redirect_to (@order.total > min_3d_amount) ? response["payment_method"]["url"] : details_order_path(@order.uuid)
      rescue OpenpayTransactionException => e
        @order.denied!
        flash[:error] = "#{e.description}, por favor, inténtalo de nuevo."
        redirect_to finance_path(:table => "purchases")
      end
    else
      redirect_to request.referer, alert: "No se pudo crear tu orden, asegurate de elegir un método de pago."
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
        # Queue job to finish the order in 72 hours
        if ENV.fetch("RAILS_ENV") == "production"
          FinishOrderWorker.perform_in(72.hours, @order.id)
        else
          FinishOrderWorker.perform_in(10.seconds, @order.id)
        end
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
      pay_to_customer(@order, @transfer)
      # End openpay call
      if @order.completed!
        if @order.dispute
          @order.dispute.proceeded!
        end
        #Charge the fee
        charge_fee(@order, @fee)
        #charge tax
        charge_tax(@order, @fee)
        # charge openpay tax
        openpay_tax(@order, @fee)
        flash[:success] = "La orden ha finalizado"
        create_reviews(@order)
        create_notification(@order.employer, @order.employee, "ha finalizado", @order.purchase, "sales", @employee_review.id)
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
    else
      flash[:error] = "Hubo un error en tu solicitud"
    end
      redirect_to finance_path(:table => "purchases", :review => true, :identifier => @employer_review.id)
  end


  def refund
    if @order.refund_in_progress!
      request_hash = {
        "description" => "Monto de la orden #{@order.uuid} devuelto por la cantidad de #{@order.total}",
        "amount" => @order.total
      }
      begin
        response = @charge.refund(@order.response_order_id ,request_hash, @order.employer.openpay_id)
        @order.update(response_refund_id: response["id"])
        if current_user == @order.employer
          flash[:success] = "La orden esta en proceso de reembolso, recibiras un correo cuando la orden ya haya sido reembolsada"
        else
          create_notification(@order.employee, @order.employer, "te ha reembolsado", @order, "purchases")
        end
      rescue
        flash[:error] = "Ocurrio un error al intentar de reembolsar la orden"
      end
    else
      flash[:error] = "Ocurrio un error al intentar de reembolsar la orden"
    end
    redirect_to finance_path(:table => "purchases")
  end

  def details
  end

  def update_details
    if @order.update_attributes(order_details_params)
      flash[:success] = "Se ha actualizado la orden con los nuevos detalles."
    else
      flash[:error] = "Hubo un error actualizando los datos."
    end
    redirect_to finance_url(:table => "purchases")
  end

  private

    # Only allow a trusted parameter "white list" through.
    def order_params
      order_params = params.require(:order).permit(:card_id, :purchase, :purchase_type, :billing_profile_id)
      order_params = set_defaults(order_params)
    end

    def order_details_params
      order_params = params.require(:order).permit(:details, :address)
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

    def get_order_by_uuid
      @order = Order.find_by_uuid(params[:id])
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
      # check if is not admin (it shoould be a normal user)
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

    # Make sure the billing profile is legit
    def check_billing_profile
      if order_params[:billing_profile_id] != nil
        cancel_execution if (current_user.billing_profiles.find_by_status("enabled").id != order_params[:billing_profile_id].to_i)
      end
    end
end

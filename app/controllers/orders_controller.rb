class OrdersController < ApplicationController
  before_action :authenticate_user!
  include BannedFunctions
  before_action :redirect_if_user_banned, only: [:create]
  include SetLayout
  include OpenpayHelper
  include OpenpayFunctions
  include UsersHelper
  include ApplicationHelper
  include OrderFunctions
  include MoneyHelper
  layout :set_layout
  access user: :all, admin: [:complete, :refund, :pass_payment, :deny_payment]
  before_action only: [:create] do
    init_openpay("charge")
  end
  before_action only: [:create, :complete, :refund] do
    init_openpay("transfer")
  end
  before_action only: [:complete] do
    init_openpay("fee")
  end
  before_action :get_order_by_uuid, only: [:request_start, :start, :request_complete, :complete, :refund, :pass_payment, :deny_payment]
  # before_action :verify_order_employee, only: [:start, :request_complete]
  # before_action :verify_order_owner, only: [:complete]
  # before_action :verify_owner_or_employee, only: [:refund]
  # before_action :verify_charge_response, except: [:create]
  # before_action :check_if_can_refund, only: [:refund]
  # before_action :check_if_request_banned, only: [:start, :request_complete, :complete, :refund]
  # before_action :check_if_order_refunded, only: [:start, :request_complete, :complete, :refund]
  #just create validators
  before_action :check_card_present, only: :create
  before_action :verify_availability, only: [:create]
  before_action :verify_order_limit, only: [:create]
  before_action :check_billing_profile, only: :create
  before_action :verify_personal_information, only: :create
  before_action :check_if_changes, only: :create

  def create
    @order = Order.new(order_params)
    @order.payout_left = reverse_price_calc(@order.total)
    min_3d_amount = 100
    if @order.save
      request_hash = make_request_hash(min_3d_amount)
      create_order(@order, request_hash, min_3d_amount)
    else #talent already hired
      redirect_to request.referer, alert: @order.errors.full_messages.first
    end

  end #create end

  def request_complete
      @order.completed_at = Time.now.in_time_zone.strftime("%Y-%m-%d %H:%M:%S")
      if @order.save
        flash[:success] = "La orden se actualizó correctamente"
        create_notification(@order.employee, @order.employer, "solicitó finalizar", @order.purchase, "purchases")
        OrderMailer.order_request_finish(@order).deliver
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
        @order.update(started_at: Time.now.in_time_zone.strftime("%Y-%m-%d %H:%M:%S"))
        flash[:success] = "La orden está en progreso"
        create_notification(@order.employee, @order.employer, "ha comenzado", @order.purchase, "purchases")
        OrderMailer.order_started(@order).deliver
      else
        flash[:error] = "Hubo un error en tu solicitud"
      end
      redirect_to finance_path(:table => "sales")
  end

  def complete
    #if the order is disputed just the admin can complete it
    @order.with_lock do #prevent double execution if worker completes at same time
      if @order.in_progress? ||( @order.disputed? && current_user.has_roles?(:admin) )
        # End openpay call
        if @order.completed!
          if @order.dispute
            @order.dispute.proceeded!
          end
          #Openpay call to transfer the fee to the Employee
          pay_to_customer(@order, @transfer)
          #Charge the fee
          charge_fee(@order, @fee)
          #charge tax
          charge_tax(@order, @fee)
          # charge openpay tax
          openpay_tax(@order, @fee)
          flash[:success] = "La orden ha finalizado"
          create_reviews(@order)
          OrderMailer.order_finished(@order).deliver
          create_notification(@order.employer, @order.employee, "ha finalizado", @order.purchase, nil, @employee_review.id)
          redirect_to root_path(:identifier => @employer_review.id)
        end # end of order.completed!
      else #not in progress
        flash[:notice] = "La orden ya fue completada antes"
        redirect_to root_path
      end
    end
  end


  def refund
    @order.with_lock do
      if @order.purchase_type == "Offer"
        request = @order.purchase.request
        request.with_lock do
          @success = request.update(status: "closed", passed_active_order: @order, c_user: current_user) #refund and also closes request, its fast to pass the order than search it in model, this triggers request.refund_money
        end
      else
        @success = @order.update(status: "refund_in_progress", c_user: current_user) #refund gig
      end
      if @success
        flash[:success] = "La orden está en proceso de reembolso, recibirás un correo cuando la orden ya haya sido reembolsada" if current_user == @order.employer
      else
        flash[:error] = (request.present?)? request.errors.full_messages.first : @order.errors.full_messages.first
      end
      redirect_to finance_path(:table => (current_user == @order.employer)? "purchases" : "sales")
    end
  end

  def pass_payment
    if @order.payment_verification_passed!
      flash[:success] = "Se ha actualizado el pago de la orden #{@order.uuid} a verificado"
    else
      flash[:error] = "Ocurrio un error al tratar de actualizar la orden #{@order.uuid}"
    end
    redirect_to orders_admins_path
  end

  def deny_payment
    if @order.payment_verification_failed!
      open_payment_ticket(@order)
      flash[:success] = "Se ha actualizado el pago de la orden #{@order.uuid} a fallido"
      redirect_to ticket_path(@order.employee.tickets.last)
    else
      flash[:error] = "Ocurrio un error al tratar de actualizar la orden #{@order.uuid}"
      redirect_to orders_admins_path
    end
  end

  private

    # Only allow a trusted parameter "white list" through.
    def order_params
      order_params = params.require(:order).permit(:card_id, :purchase, :purchase_type, :billing_profile_id, :details, :address, :quantity)
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
        if parameters[:quantity].present?
          validate_quantity_range(pack, parameters[:quantity].to_i)
          parameters[:total] = (calc_packages_units(pack.price * parameters[:quantity].to_i))
          parameters[:unit_type] = pack.unit_type
          parameters[:unit_count] = parameters[:quantity]
          parameters.delete :quantity
        else
          parameters[:total] = purchase_order_total(pack.price).round(2)
        end
        parameters
    end

    def open_payment_ticket(order)
      ticket_description = "Estimado usuario. Se ha detectado una anomalía en el método de pago de la orden #{order.uuid}.
Por ese motivo para poder darle segumiento a su caso hemos creado este ticket de soporte, el cual tendrá documentado todo el proceso.
El monto por la cantidad de #{order.total} será retenido hasta que esta situación sea clarada o hasta que hayan transcurrido un total de 90 días.

Preguntas precuentes:
1) ¿Por qué 90 dias?
Es el periodo que se le da a una persona para aclarar la situación.

2) ¿Qué debo hacer?
Por el momento nada, nosotros intentaremos ponernos en contacto con el comprador para verificar la información"
      Ticket.create!(title: "Pago de orden denegada #{order.uuid} por la cantidad de #{order.total}",
        description: ticket_description,
        priority: "low", user: order.employee, current_user: current_user)
    end

    # Enable 3d secure transactions
    def enable_secure_transactions
      if current_user.secure_transaction
        job = Sidekiq::ScheduledSet.new.find_job([current_user.secure_transaction_job_id])
        job.delete
        current_user.update(secure_transaction_job_id: nil)
      else
        current_user.update(secure_transaction: true)
      end
      # job to disable secure transactions after 3 days
      secure_transaction_job = DisableSecureTransactionsWorker.perform_in(72.hours, current_user.id)
      current_user.update(secure_transaction_job_id: secure_transaction_job)
    end

    def validate_quantity_range (pa, quan) # pa = package, quan = quantity
      if pa.min_amount.nil? || pa.max_amount.nil? || quan < pa.min_amount || pa.max_amount < quan
        redirect_to request.referrer, alert: "Rango de compra no admitido."
        return false
      end
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
      #normal users, except admin and owners can pass this
      if @order.employer != current_user && @order.employee != current_user && ! current_user.has_role?(:admin)
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

    def invalid_state(state)
      state.each do |s|
        if @order.status == s
          flash[:error] = "No se puede completar la transacción"
          break
        end
      end
    end

    def verify_order_limit
      if current_user.purchases.pending.length >= 5
        flash[:error] = "No puedes tener más de 5 compras pendientes"
        redirect_to finance_path(:table => "purchases")
      end
    end

    def check_if_can_refund
      invalid_state(["completed", "refunded", "refund_in_progress","denied","waiting_for_bank_approval"])
      # check if is not admin (it shoould be a normal user)
      if ! current_user.has_roles?(:admin)
        # Cancel transaction if the order is on any of these states
        invalid_state(["disputed"])
        #employer cant refund orders in progress
        if @order.in_progress? && (current_user == @order.employer)
          invalid_state(["in_progress"])
        end
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
      flash[:error] = "Este recurso no está disponible"
      redirect_to root_path
      return
    end

    # Make sure the billing profile is legit
    def check_billing_profile
      if order_params[:billing_profile_id] != nil
        cancel_execution if (current_user.billing_profiles.find_by_status("enabled").id != order_params[:billing_profile_id].to_i)
      end
    end

    def verify_personal_information
      if current_user.name.blank?
        flash[:error] = "Asegurate de tener tu nombre completo en Jalecitos para proceder a comprar"
        redirect_to configuration_path(bestFocusAfterReload: "change_user_name")
      end
    end

    def check_card_present
      if ! params[:order][:card_id].present?
        redirect_to request.referer, alert: "No se pudo crear tu orden, asegúrate de elegir un método de pago."
      end
    end

    def check_if_changes
      object = @package || @offer
      load_time = params[:order][:load_time].to_time - 0.5.seconds #the time is when server is in the view, i need the time of controller (when get info of resource), so i  subtract half of second
      if load_time < object.updated_at
        flash[:notice] = "Se han hecho cambios al recurso que está a punto de contratar, por favor, verifique la información"
        redirect_back(fallback_location: root_path)
      end
    end

    def make_request_hash(min_3d_amount)
      {
        "method" => "card",
        "source_id" => order_params[:card_id],
        "cvv2" => (current_user.cards.find_by_openpay_id(order_params[:card_id]).cvv rescue 123),
        "amount" => @order.total,
        "currency" => "MXN",
        "description" => "Compraste #{@order.purchase_type} con el id: #{@order.purchase.id}, por la cantidad de #{@order.total}. orden ID: #{@order.uuid}",
        "device_session_id" => params[:device_id],
        "use_3d_secure" => secure_transaction?(@order.total, min_3d_amount),
        "redirect_url" => finance_url(table: "purchases")
      }
    end

    def check_if_request_banned
      if @order.purchase_type == "Offer" #is an order of a request
        request = @order.purchase.request
        if request.banned?
          flash[:notice] = "El recurso está bloqueado, se reembolsará el dinero"
          redirect_to_table(@order)
        end
      end
    end

    def redirect_to_table order
      if order.employer == current_user
        redirect_to finance_path(table: "purchases")
      else
        redirect_to finance_path(table: "sales")
      end
    end

    def check_if_order_refunded
      if @order.refund_in_progress? || @order.refunded?
        flash[:error] = "La orden no pudo ser actualizada"
        redirect_to_table(@order)
      end
    end
end

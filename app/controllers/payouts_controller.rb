class PayoutsController < ApplicationController
  include ApplicationHelper
  include OpenpayHelper
  before_action :authenticate_user!
  access user: :all
  before_action :set_payouts, only: :show
  before_action :validate_previous_payouts, only: :create
  before_action only: [:create] do
    init_openpay("payout")
  end

  def create
    @orders = current_user.unpaid_orders
    if @orders.count > 0
      @jalecitos_payout = Payout.new(user: current_user, bank_id: params[:bank_id])
      if @jalecitos_payout.save
        if @orders.update_all(payout_id: @jalecitos_payout.id)
          ########### Payout Creation ##########
          @order_total = @jalecitos_payout.orders.sum(:total)
          # based on the total, calculate the corresponding money to the user
          @employee_balance = calc_employee_orders_earning(@order_total, @jalecitos_payout.orders.count)
          request_hash={
           "method" => "bank_account",
           "destination_id" => @jalecitos_payout.bank_id,
           "amount" => @employee_balance,
           "description" => "Retiro del usuario #{@jalecitos_payout.user.email}",
           "order_id" => "payout-#{@jalecitos_payout.id}"
          }
          begin
            response = @payout.create(request_hash, @jalecitos_payout.user.openpay_id)
            @jalecitos_payout.update(transaction_id: response["id"])
            flash[:success] = "Tu pago esta en proceso. Recibiras una notificacion por correo una vez que se haya procesado."
          rescue OpenpayTransactionException => e
            flash[:error] = "El pago no pudo ser concretado por la siguiente razon. #{e.description}. Intenta de nuevo mas tarde o comunicate con soporte para resolverlo."
            @jalecitos_payout.failed!
          end
          ###########
        # deny payout in case the order update all failed
        else
          flash[:error] = "Ocurrio un error procesando tu pago, por favor contactar a soporte para resolverlo."
          @@jalecitos_payout.failed!
        end
      end
    else
      flash[:error] = "Debes tener mas de $100 MXN para poder retirar."
    end
    redirect_to configuration_path(collapse: "withdraw")
  end

  def show
  end

  private

  def set_payouts
    Payout.where(user: current_user)
  end

  def validate_previous_payouts
    if current_user.payouts.where(status: "pending").count > 0
      flash[:notice] = "Tienes un pago en proceso."
      redirect_to configuration_path(collapse: "withdraw")
      return false
    end
  end
end

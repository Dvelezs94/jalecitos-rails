class PayoutsController < ApplicationController
  include ApplicationHelper
  include OpenpayHelper
  include OrderFunctions
  include LevelHelper
  before_action :authenticate_user!
  access user: :create, admin: [:process, :fail]
  before_action :set_payouts, only: :show
  before_action :validate_previous_payouts, only: :create
  before_action :min_payout_amount, only: [:create, :process]
  before_action only: [:create] do
    init_openpay("payout")
  end

  def create
    @jalecitos_payout = Payout.new(user: current_user, bank_id: params[:bank_id], level: current_user.score.level)
    if @jalecitos_payout.save
      @orders_array = []
      if Order.where(id: @orders_array).update_all(payout_id: @jalecitos_payout.id)
        flash[:success] = "Tu pago esta en proceso. Recibirás una notificacion por correo una vez que se haya procesado."
      # deny payout in case the order update all failed
      else
        flash[:error] = "Ocurrió un error procesando tu pago, por favor, contacta a soporte para resolverlo."
        @jalecitos_payout.failed!
      end
    end
    redirect_to configuration_path(collapse: "withdraw")
  end

  def process
    @jalecitos_payout = Payout.find(params[:id])
    @orders_array = []
    @payment_hash[0][:orders].each {|o| @orders_array <<  o[:id]}
    begin
      ########### Payout Creation ##########
      request_hash={
       "method" => "bank_account",
       "destination_id" => @jalecitos_payout.bank_id,
       "amount" => (@payment_hash[0][:count] * calc_level_percent(@jalecitos_payout.level)).round(2),
       "description" => "Retiro del usuario #{@jalecitos_payout.user.email}",
       "order_id" => "payout-#{current_user.id}-#{@jalecitos_payout.id}"
      }

      response = @payout.create(request_hash, @jalecitos_payout.user.openpay_id)
      @jalecitos_payout.update(transaction_id: response["id"])
      @jalecitos_payout.pending!
      flash[:success] = "El pago está en proceso."
    rescue OpenpayTransactionException => e
      flash[:error] = "El pago no pudo ser concretado. error: #{e.description}"
    rescue => e
      flash[:error] = "Error desconocido: #{e}"
    end
  end

  def fail
    @jalecitos_payout = Payout.find(params[:id])
    if @jalecitos_payout.failed!
      flash[:success] = "El pago se actualzó a fallido"
    end
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

  def min_payout_amount
    @orders = current_user.unpaid_orders
    # calculate orders and money to give to the user.
    # this function collects the ids that fit on a desired amount (eg 5000)
    #  it returns the ids that fit
    @payment_hash = calc_payout(@orders)
    if @orders.count == 0
      flash[:error] = "No tienes pagos pendientes"
    elsif @payment_hash[0][:count] < 100
      flash[:error] = "Debes tener al menos $100 MXN para poder retirar."
    end

    if flash[:error]
      redirect_to configuration_path(collapse: "withdraw")
    end
  end
end

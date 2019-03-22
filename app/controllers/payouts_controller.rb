class PayoutsController < ApplicationController
  include ApplicationHelper
  include OpenpayHelper
  include OrderFunctions
  include LevelHelper
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
      @jalecitos_payout = Payout.new(user: current_user, bank_id: params[:bank_id], level: current_user.score.level)
      # calculate orders and money to give to the user.
      # this function collects the ids that fit on a desired amount (eg 5000)
      #  it returns the ids that fit
      @payment_hash = calc_payout(@orders)
      if @jalecitos_payout.save
        @orders_array = []
        @payment_hash[0][:orders].each {|o| @orders_array <<  o[:id]}
        if Order.where(id: @orders_array).update_all(payout_id: @jalecitos_payout.id)
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
          flash[:success] = "Tu pago esta en proceso. Recibiras una notificacion por correo una vez que se haya procesado."
        rescue
          flash[:error] = "El pago no pudo ser concretado. Intenta de nuevo mas tarde o comunicate con soporte para resolverlo."
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

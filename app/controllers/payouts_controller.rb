class PayoutsController < ApplicationController
  before_action :authenticate_user!
  access user: :all
  before_action :set_payouts, only: :show
  before_action :validate_previous_payouts, only: :create

  def create
    @orders = current_user.unpaid_orders
    if @orders.count > 0
      @payout = Payout.new(user: current_user)
      if @payout.save
        if @orders.update_all(payout_id: @payout.id)
          flash[:success] = "Tu pago esta en proceso. Recibiras una notificacion por correo una vez que este procesado."
          # deny payout in case the order update all failed
        else
          flash[:error] = "Ocurrio un error procesando tu pago, por favor contactar a soporte para resolverlo."
          @payout.failed!
        end
      end
    else
      flash[:error] = "Debes tener mas de $100 MXN para poder retirar."
    end
    redirect_to "#{configuration_path}#bank"
  end

  def show
  end

  private

  def set_payouts
    Payout.where(user: current_user)
  end

  def validate_previous_payouts
    if current_user.payouts.where(status: "pending").count > 0
      flash[:error] = "Tienes un pago en proceso."
      redirect_to "#{configuration_path}#bank"
      return false
    end
  end
end

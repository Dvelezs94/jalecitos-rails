class WithdrawalsController < ApplicationController
  before_action :authenticate_user!
  include OpenpayHelper
  include UsersHelper
  access user: :all
  before_action only: [:create] do
    init_openpay("payout")
  end

  def my_withdrawals
    @withdrawals = @payout.all(current_user.openpay_id)
  end

  # POST /requests
  def create
    @withdrawal = Withdrawal.new(user: current_user)
    @amount = current_user.balance[:amount].to_f - 8
    if @amount < 100.0
      flash[:error] = "Debes tener arriba de $100 MXN para poder disponer."
      redirect_to configuration_path
      return
    end
    @order_ids = current_user.balance[:order_ids]
    request_hash={
     "method" => "bank_account",
     "destination_id" => params[:bank_id],
     "amount" => @amount,
     "description" => "Retiro del usuario #{current_user.slug}"
    }

    if @withdrawal.save
     begin
       @order_ids.each do |o|
         @order = Order.find(o)
         @order.withdrawal = @withdrawal
         @order.save
       end
       response = @payout.create(request_hash, current_user.openpay_id)
       flash[:success] = "La cantidad de #{@amount} fue depositada exitosamente"
       redirect_to configuration_path
     rescue OpenpayException => e
       @withdrawal.denied!
       flash[:error] = "#{e.description}, por favor intentalo de nuevo mas tarde."
       redirect_to configuration_path
     end
    end

  end
end

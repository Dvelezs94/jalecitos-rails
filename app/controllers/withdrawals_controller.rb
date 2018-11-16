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
    @withdrawal = Withdrawal.new(withdraw_params)
    @amount = current_user.balance[:amount].to_f - 8
    @order_ids = current_user.balance[:order_ids]
    request_hash={
     "method" => "bank_account",
     "destination_id" => @withdrawal.bank_id,
     "amount" => @amount,
     "description" => "Retiro del usuario #{current_user.slug}"
    }

    if @withdrawal.save
     begin
       response = @payout.create(request_hash, current_user.openpay_id)
       @order_ids.each do |o|
         @order = Order.find(o)
         @order.withdrawal = @withdrawal
         @order.save
       end
       flash[:success] = "La cantidad de #{@amount} fue depositada exitosamente"
       redirect_to user_config_path
     rescue OpenpayException => e
       flash[:error] = "#{e.description}, por favor intentalo de nuevo mas tarde."
       redirect_to user_config_path
     end
    end

  end

  private
    def request_params
      withdraw_params = params.require(:withdraw).permit(:bank_id)
    end
end

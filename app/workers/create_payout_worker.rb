class CreatePayoutWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    if ! @payout.pending?
      return true
    end
    @jalecitos_payout = Payout.find(payout_id)
    init_openpay("payout")
    @order_total = @jalecitos_payout.orders.sum(:total)
    # based on the total, calculate the corresponding money to the user
    @employee_balance = calc_employee_orders_earning(@order_total, @jalecitos_payout.orders.count)
    request_hash={
     "method" => "bank_account",
     "destination_id" => @jalecitos_payout.bank_id,
     "amount" => @employee_balance,
     "description" => "Retiro del usuario #{current_user.slug}"
    }
    begin
      response = @payout.create(request_hash, @jalecitos_payout.user.openpay_id)
    rescue OpenpayTransactionException => e
      @jalecitos_payout.failed!
      PayoutMailer.failed_payout(@jalecitos_payout.user, @employee_balance, e.description)
    end
  end
end

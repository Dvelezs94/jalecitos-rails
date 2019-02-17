class CreatePayoutWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    @jalecitos_payout = Payout.find(payout_id)
    if ! @jalecitos_payout.pending?
      return true
    end
    init_openpay("payout")
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
    rescue OpenpayTransactionException => e
      PayoutMailer.failed_payout(@jalecitos_payout.user, @employee_balance, e.description).deliver
      @jalecitos_payout.failed!
    end
  end
end

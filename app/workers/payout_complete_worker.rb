class PayoutCompleteWorker
  include Sidekiq::Worker
  include OrderFunctions
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    @jalecitos_payout = Payout.find_by_transaction_id(payout_id)
    @employee_balance = calc_payout(@jalecitos_payout.orders)[0][:count]
    if ! @jalecitos_payout.pending?
      return true
    end
    if update_orders_status(calc_payout(@jalecitos_payout.orders)[0][:orders])
      begin
        @jalecitos_payout.completed!
        PayoutMailer.successful_payout(@jalecitos_payout.user, @employee_balance).deliver
      rescue
        PayoutMailer.notify_inconsistency(@jalecitos_payout.user).deliver
      end
    end
  end

  def update_orders_status(orders_hash)
    orders_hash.each do |o|
      if o[:payout_left] == 0
        Order.find(o[:id]).update(paid_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"), payout_left: o[:payout_left])
      else
        Order.find(o[:id]).update(payout_left: o[:payout_left])
      end
    end
  end
end

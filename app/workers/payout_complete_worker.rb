class PayoutCompleteWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    @jalecitos_payout = Payout.find_by_transaction_id(payout_id)
    @employee_balance = calc_employee_orders_earning(@jalecitos_payout.orders.sum(:total), @jalecitos_payout.orders.count)
    if ! @jalecitos_payout.pending?
      return true
    end
    if @jalecitos_payout.orders.update_all(paid_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
      begin
        @jalecitos_payout.completed!
        PayoutMailer.successful_payout(@jalecitos_payout.user, @employee_balance).deliver
      rescue
        PayoutMailer.notify_inconsistency(@jalecitos_payout.user).deliver
      end
    end
  end
end

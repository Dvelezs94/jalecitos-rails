class PayoutFailedWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id, error)
    @jalecitos_payout = Payout.find(payout_id)
    @employee_balance = calc_employee_orders_earning(@jalecitos_payout.orders.sum(:total), @jalecitos_payout.orders.count)
    if ! @jalecitos_payout.pending?
      return true
    end
    @jalecitos_payout.failed!
    PayoutMailer.failed_payout(@jalecitos_payout.user, @employee_balance, error).deliver
  end
end

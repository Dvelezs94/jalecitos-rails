class PayoutFailedWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, dead: false
  include OrderFunctions
  include ApplicationHelper
  

  def perform(payout_id, error)
    @jalecitos_payout = Payout.find_by_transaction_id(payout_id)
    @employee_balance = calc_payout(@jalecitos_payout.orders)[0][:count]
    if ! @jalecitos_payout.pending?
      return true
    end
    @jalecitos_payout.failed!
    PayoutMailer.failed_payout(@jalecitos_payout.user, @employee_balance, error).deliver
  end
end

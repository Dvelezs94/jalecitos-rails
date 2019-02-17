class PayoutCompleteWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    @jalecitos_payout = Payout.find(payout_id)
    @employee_balance = @jalecitos_payout.orders.sum(:total)
    if ! @jalecitos_payout.pending?
      return true
    end
    if @jalecitos_payout.completed!
      PayoutMailer.successful_payout(@jalecitos_payout.user, @employee_balance).deliver
    else
      PayoutMailer.notify_inconsistency(@jalecitos_payout.user).deliver
    end
  end
end

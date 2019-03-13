class PayoutCompleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include OrderFunctions
  include ApplicationHelper
  include OpenpayHelper

  def perform(payout_id)
    # get payout id
    @jalecitos_payout = Payout.find_by_transaction_id(payout_id)
    # get balance
    @employee_balance = calc_payout(@jalecitos_payout.orders)[0][:count]
    if ! @jalecitos_payout.pending?
      return true
    end
    begin
      p "orders_array = #{calc_payout(@jalecitos_payout.orders)[0][:orders]}"
      update_orders_status(calc_payout(@jalecitos_payout.orders)[0][:orders])
      begin
        @jalecitos_payout.completed!
        PayoutMailer.successful_payout(@jalecitos_payout.user, @employee_balance).deliver
      end
    rescue => exception
      Bugsnag.notify(exception)
      PayoutMailer.notify_inconsistency(@jalecitos_payout.user).deliver
    end
  end

  def update_orders_status(orders_array)
    orders_array.each do |o|
      if o[:payout_left] == 0
        p "updating #{o} with 0 payout_left"
        Order.find(o[:id]).update!(paid_at: Time.now.strftime("%Y-%m-%d %H:%M:%S"), payout_left: o[:payout_left])
      else
        p "updating #{o} with #{o[:payout_left]} payout_left"
        Order.find(o[:id]).update!(payout_left: o[:payout_left])
      end
    end
  end
end

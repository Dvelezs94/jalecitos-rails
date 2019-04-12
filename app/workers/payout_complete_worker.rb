class PayoutCompleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include OrderFunctions
  include ApplicationHelper
  include OpenpayHelper
  include LevelHelper

  def perform(payout_id)
    # get payout id
    @jalecitos_payout = Payout.find_by_transaction_id(payout_id)
    # handle payouts that dont exist, for example when we get paid to the company account
    if @jalecitos_payout.blank?
      return true
    end
    # get balance
    @employee_balance = calc_payout(@jalecitos_payout.orders)[0][:count]
    @employee_balance_minus_fee = (@employee_balance * (1 - calc_level_percent(@jalecitos_payout.level))).round(2)
    if ! @jalecitos_payout.pending?
      return true
    end
    begin
      update_orders_status(calc_payout(@jalecitos_payout.orders)[0][:orders])
      begin
        @jalecitos_payout.completed!
        PayoutMailer.successful_payout(@jalecitos_payout.user, @employee_balance_minus_fee).deliver
        charge_payout_fee
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

  # charge fee from presdispersion account
  def charge_payout_fee
    init_openpay("fee")
    request_payout_fee={"customer_id" => ENV.fetch("OPENPAY_PREDISPERSION_CLIENT"),
                   "amount" => @employee_balance_minus_fee,
                   "description" => "Cobro de impuesto por payout #{@jalecitos_payout.id}",
                  }
    @fee.create(request_payout_fee)
  end
end

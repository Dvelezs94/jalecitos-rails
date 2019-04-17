class PayoutCompleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include OrderFunctions
  include ApplicationHelper
  include OpenpayHelper
  include LevelHelper
  include PushFunctions

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
    @balance_left = @employee_balance - @employee_balance_minus_fee - 9.28
    if ! @jalecitos_payout.pending?
      return true
    end
    begin
      update_orders_status(calc_payout(@jalecitos_payout.orders)[0][:orders])
      @jalecitos_payout.completed!
      PayoutMailer.successful_payout(@jalecitos_payout.user, @balance_left).deliver
      send_payout_push
      charge_payout_fee
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

  def send_payout_push
    @message = {
      notification: {
        title: "Fondos Depositados",
        body:  "Los fondos por la cantidad de #{@balance_left} han sido depositados",
        icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png",
        click_action: "https://www.jalecitos.com/",
        badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png"
      },
      webpush: {
        headers: {
          Urgency: "high"
        }
     }
    }

    createFirebasePush(@jalecitos_payout.user_id, @message)
  end
end

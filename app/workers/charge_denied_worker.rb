class ChargeDeniedWorker
  include Sidekiq::Worker
  include ApplicationHelper

  def perform(response, error_message)
    @order = Order.find_by_response_order_id(response)
    if ! @order.waiting_for_bank_approval?
      return true
    end
    @order.denied!
    ChargesMailer.charge_denied(@order, error_message).deliver
  end
end

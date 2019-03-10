class ChargeDeniedWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  include ApplicationHelper

  def perform(response, error_message)
    @order = Order.find_by_response_order_id(response)
    # if order doesnt exist, finish job gracefuly
    return true if ! defined? @order
    # finish job if the order was already handled before
    return true if ! @order.waiting_for_bank_approval?

    @order.denied!
    ChargesMailer.charge_denied(@order, error_message).deliver
  end
end

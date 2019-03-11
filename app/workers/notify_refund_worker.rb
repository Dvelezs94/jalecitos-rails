class NotifyRefundWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include ApplicationHelper

  def perform(refund_id)
    @order = Order.find_by_response_refund_id(refund_id)
    if  @order.refunded!
      #if the order has a dispute (and obviously is disputed...)
      if @order.dispute
        #change dispute status to refunded
        @order.dispute.refunded!
      end
      if @order.purchase_type == "Offer"
        @order.purchase.request.closed!
      end
    end
    ChargesMailer.charge_refunded(@order).deliver
  end
end

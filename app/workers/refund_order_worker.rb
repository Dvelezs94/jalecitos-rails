class RefundOrderWorker
  include Sidekiq::Worker
  # wait 6 hours before retrying
  sidekiq_retry_in do |count|
    21600
  end
  include ApplicationHelper
  include OpenpayHelper


  def perform(order_id)
    init_openpay("charge")
    init_openpay("transfer")

    @order = Order.find(order_id)

    if @order.response_refund_hold_id.nil?
      transfer_hold_to_user(@order)
    end
    if @order.response_refund_id.nil?
      refund_to_card(@order)
    end
  end

  def transfer_hold_to_user order
    # Move money from hold account to employer account
    request_transfer_hash_hold = {
      "customer_id" => order.employer.openpay_id,
      "amount" => calc_refund(order.total),
      "description" => "reembolso de orden #{order.uuid} por la cantidad de #{calc_refund(order.total)}",
      "order_id" => "#{order.uuid}-refund"
    }
    begin
      response = @transfer.create(request_transfer_hash_hold, ENV.fetch("OPENPAY_HOLD_CLIENT"))
      order.response_refund_hold_id = response["id"]
      order.save
    rescue OpenpayTransactionException => e
      p "Error trying to refund order #{order.uuid} on transfering funds, error: #{e}"
      return false
    end
  end

  def refund_to_card order
    # Refund money to card from employer openpay account
    request_hash = {
      "description" => "Monto de la orden #{order.uuid} devuelto por la cantidad de #{calc_refund(order.total)}",
      "amount" => calc_refund(order.total)
    }
    begin
      response = @charge.refund(order.response_order_id ,request_hash, order.employer.openpay_id)
      order.response_refund_id = response["id"]
      order.save
      if  order.refunded!
        #if the order has a dispute (and obviously is disputed...)
        if order.dispute
          #change dispute status to refunded
          order.dispute.refunded!
        end
        if order.purchase_type == "Offer"
          order.purchase.request.closed!
        end
      end
      ChargesMailer.charge_refunded(order).deliver
    rescue OpenpayException => e
      p "Error trying to refund order #{order.uuid}, error: #{e}"
      return false
    rescue
      p "Something went wrong refunding order #{order.uuid}"
    end
  end

end

class TransferFundsAfterThreeDWorker
  include Sidekiq::Worker
  include ApplicationHelper
  include OpenpayHelper

  def perform(response)
    init_openpay("transfer")

    @order = Order.find_by_response_order_id(response)
    ###### transfer money to hold account ######
    request_transfer_hash = {
      "customer_id" => ENV.fetch("OPENPAY_HOLD_CLIENT"),
      "amount" => purchase_order_total(@order.total),
      "description" => "transferencia de orden #{@order.uuid} por la cantidad de #{purchase_order_total(@order.total)}",
      "order_id" => "#{@order.uuid}-hold"
    }
    begin
      @transfer.create(request_transfer_hash, @order.employer.openpay_id)
      @order.pending!
    rescue OpenpayException => e
      return false
    end

    # Create notification after the funds are moved
    if @order.purchase_type == "Offer"
      # set request in progress, so no more offers are made
      @order.purchase.request.update(employee: @order.purchase.user)
      @order.purchase.request.in_progress!
      OrderMailer.new_request_order_to_employee(@order).deliver if @order.employee.transactional_emails
      OrderMailer.new_request_order_to_employer(@order).deliver if @order.employer.transactional_emails
    else
      OrderMailer.new_gig_order_to_employee(@order).deliver if @order.employee.transactional_emails
      OrderMailer.new_gig_order_to_employer(@order).deliver if @order.employer.transactional_emails
    end
    create_notification(@order.employer, @order.employee, "te contrató", @order.purchase, "sales")
  end


end

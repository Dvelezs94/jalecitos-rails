class UpdateOrderAfterPaymentSuccessWorker
  include Sidekiq::Worker
  include ApplicationHelper

  def perform(response)

    @order = Order.find_by_response_order_id(response)
    # finish job if id doesnt exist
    return true if ! defined? @order
    #  handle double send from openpay
    return true if ! @order.waiting_for_bank_approval?

    if @order.pending!
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


end

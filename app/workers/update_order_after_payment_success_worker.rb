class UpdateOrderAfterPaymentSuccessWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include ApplicationHelper

  def perform(response)

    @order = Order.find_by_response_order_id(response)
    @order.with_lock do #one at time
      # finish job if id doesnt exist
      return true if @order.blank?
      #  handle double send from openpay
      return true if (! @order.waiting_for_bank_approval?) || @order.denied?

      if @order.purchase.nil? #gig or was deleted
        @order.denied!
        return true
      end

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
        create_notification(@order.employee, @order.employer, "Se ha validado", @order.purchase, "purchases")
        puts "X"*500
      end
    end
  end
end

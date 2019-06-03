class UpdateOrderAfterPaymentSuccessWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include OpenpayFunctions
  include OpenpayHelper
  include ApplicationHelper

  def perform(response)

    @order = Order.find_by_response_order_id(response)
    @order.with_lock do #one at time
      # finish job if id doesnt exist
      return true if @order.blank?
      #  handle double send from openpay
      return true if (! @order.waiting_for_bank_approval?)

      if @order.purchase.nil? #gig was deleted meanwhile payment was approved
        @order.denied!
        return true
      end

      if @order.pending!
        # Create notification after the funds are moved
        if @order.purchase_type == "Offer"
          request = @order.purchase.request
          #check if request is banned, and try to refund because the request was banned when payment was still approving
          if request.banned?
            create_notification(@order.employee, @order.employer, "Se te reembolsará", request, "purchases")
            request.refund_money(false) #notify just to employer
            return true
          end
          # set request in progress, so no more offers are made
          request.update(employee: @order.purchase.user, status: "in_progress")
          OrderMailer.new_request_order_to_employee(@order).deliver if @order.employee.transactional_emails
          OrderMailer.new_request_order_to_employer(@order).deliver if @order.employer.transactional_emails
        else
          OrderMailer.new_gig_order_to_employee(@order).deliver if @order.employee.transactional_emails
          OrderMailer.new_gig_order_to_employer(@order).deliver if @order.employer.transactional_emails
        end
        create_notification(@order.employee, @order.employer, "Se ha validado", @order.purchase, "purchases")
        create_notification(@order.employer, @order.employee, "te contrató", @order.purchase, "sales")
      end
    end
  end
end

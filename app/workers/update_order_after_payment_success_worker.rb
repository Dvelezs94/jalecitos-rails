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
      return true if (! @order.waiting_for_bank_approval?)

      if @order.purchase.nil? #gig was deleted meanwhile payment was approved
        @order.denied!
        return true
      end

      if @order.pending!
        # Create notification after the funds are moved
        if @order.purchase_type == "Offer"
          request = @order.purchase.request
          employee = @order.purchase.user
          request.with_lock do
            #check if request is banned, and try to refund because the request was banned when payment was still approving
            if request.banned? || request.closed? || (! request.user.active?)
              request.update( payment_success_and_request_banned_or_closed_or_employer_inactive: true, passed_active_order: @order)
              return true
            end
            if ( ! employee.active? ) #employer is banned or disabled, here the request will still be published and user can hire another talent
              request.update( payment_success_and_employee_not_active: true, passed_active_order: @order)
              return true
            end
            # set request in progress, so no more offers are made
            request.update(employee: @order.purchase.user, status: "in_progress")
            OrderMailer.new_request_order_to_employee(@order).deliver if @order.employee.transactional_emails
            OrderMailer.new_request_order_to_employer(@order).deliver if @order.employer.transactional_emails
          end #end of with lock
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

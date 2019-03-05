class FinishOrderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  include OpenpayFunctions
  include OrderFunctions
  include OpenpayHelper
  include ApplicationHelper

  def perform(order_id)
    @order = Order.find(order_id)
    @order.with_lock do #prevent double if user completes at same time
      if @order.in_progress?
        begin
          init_openpay("transfer")
          init_openpay("fee")
          @order.completed!
          #pat to customer openpay account
          pay_to_customer(@order, @transfer)
          #charge fee
          charge_fee(@order, @fee)
          #charge tax
          charge_tax(@order, @fee)
          # charge openpay tax
          openpay_tax(@order, @fee)
          # Create reviews and notifications
          create_reviews(@order)
          create_notification(@order.employer, @order.employee, "Se ha finalizado", @order.purchase, "sales", @employee_review.id)
          create_notification(@order.employee, @order.employer, "Se ha finalizado", @order.purchase, "purchases", @employer_review.id)
          # send email notifying the user
          OrderMailer.completed_after_72_hours(@order).deliver
        rescue
          OrderMailer.error_worker(@order.uuid).deliver
        end
      end
    end
  end
end

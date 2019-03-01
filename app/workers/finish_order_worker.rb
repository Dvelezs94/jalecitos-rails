class FinishOrderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  include OpenpayFunctions
  include OrderFunctions
  include OpenpayHelper
  include ApplicationHelper

  def perform(order_id)
    @order = Order.find(order_id)
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

        # send email notifying the user
        OrderMailer.completed_after_72_hours(@order).deliver
      rescue
        # send email leting us know something has failed in this job
        true
      end
    end
  end
end

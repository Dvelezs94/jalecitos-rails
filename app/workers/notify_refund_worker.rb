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
    end
    #on worker of payment success if the request is banned, the employee doesnt recieve notification of being hired, because it inmediately gets refunded, so when refunded is successful, employee doesnt need to know that
    employee_has_hire_notification = Notification.find_by(notifiable: @order.purchase, recipient: @order.employee).present?
    create_notification(@order.employee, @order.employer, "Se te ha reembolsado", @order, "purchases")
    create_notification(@order.employer, @order.employee, "Se ha reembolsado", @order, "sales") if employee_has_hire_notification
    ChargesMailer.charge_refunded(@order).deliver
  end
end

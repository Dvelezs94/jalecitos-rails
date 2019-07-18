class FinishOrderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  include OpenpayFunctions
  include OrderFunctions
  include OpenpayHelper
  include ApplicationHelper
  include MoneyHelper

  def perform(order_id)
    @order = Order.find(order_id)
    @order.with_lock do #prevent double if user completes at same time
      if @order.in_progress?
        @success = @order.update(status: "completed", finish_order_worker: true)
        # Create reviews and notifications
        if @success
          create_reviews(@order)
          create_notification(@order.employer, @order.employee, "Se ha finalizado", @order.purchase, nil, @employee_review.id)
          create_notification(@order.employee, @order.employer, "Se ha finalizado", @order.purchase, nil, @employer_review.id)
        end
      end
    end
  end
end

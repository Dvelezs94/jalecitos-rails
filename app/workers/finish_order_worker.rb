class FinishOrderWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  include OpenpayFunctions
  include OrderFunctions
  
  include ApplicationHelper
  include MoneyHelper

  def perform(order_id)
    @order = Order.find(order_id)
    @order.with_lock do #prevent double if user completes at same time
      @success = @order.update(status: "completed", finish_order_worker: true)
    end
  end
end

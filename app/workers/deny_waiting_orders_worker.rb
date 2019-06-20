class DenyWaitingOrdersWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    orders = Order.where(status: "waiting_for_bank_approval")
    orders.each do |o|
      o.with_lock do
        o.denied! if Time.now - o.created_at > 1.days #maybe they exit 3d secure
      end
    end
  end
end

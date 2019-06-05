class PendingRefundsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    pending_refunds = Order.where(status: "refund_in_progress", response_refund_id: nil)
    pending_refunds.each do |o|
      o.with_lock do
        o.update(pending_refund_worker: true)
        break if o.response_refund_id.nil? #break if openpay doesnt respond in one
      end
    end
  end
end

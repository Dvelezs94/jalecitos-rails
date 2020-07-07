class CloseRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    Request.published.where("? > created_at", Time.now-30.days).each do |request|
      begin
        @req = request.update(status: "closed")
      rescue => e
        Bugsnag.notify("Error en request con id:" + request.id.to_s+ " con error "+ @req.errors.full_messages.first)
      end
    end
  end
end

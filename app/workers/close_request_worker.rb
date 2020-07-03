class CloseRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    Request.published.where("? > created_at", Time.now-30.days).each do |request|
      begin
        request.update!(status: "closed")
      rescue => e
        Bugsnag.notify("Error en request con id:" + request.id+ " con error "+ e)
      end
    end
  end
end

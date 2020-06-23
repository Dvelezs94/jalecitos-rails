class CloseRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    Request.published.where("? > created_at", Time.now-30.days).each do |request|
    request.closed!
  end
end

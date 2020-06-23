class CloseRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform()
    Request.where("? > created_at", Time.now-30.days).published do
    request.closed!
  end
end

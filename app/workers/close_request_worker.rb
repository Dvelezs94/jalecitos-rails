class CloseRequestWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(request_id)
    request = Request.find(request_id)
    request.closed! if request.published?
  end
end

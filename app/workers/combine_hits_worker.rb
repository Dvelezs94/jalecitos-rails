class CombineHitsWorker
  include Sidekiq::Worker
  require 'rake'
  sidekiq_options retry: false, dead: false
  def perform()
    Jalecitos::Application.load_tasks
    Rake::Task['punching_bag:combine'].invoke
  end
end

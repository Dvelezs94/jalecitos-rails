class DisableSecureTransactionsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3, dead: false

  def perform(user_id)
    user = User.find(user_id)
    user.update_attributes(secure_transaction: false, secure_transaction_job_id: nil)
  end

end

class MarketingNotification < ApplicationRecord
  enum status: { pending: 0, running: 1, finished: 2, cancelled: 3, failed: 4 }

  # save results as hash
  serialize :filters, Hash
end

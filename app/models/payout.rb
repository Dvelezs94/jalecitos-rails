class Payout < ApplicationRecord
  belongs_to :user
  has_many :orders
  enum status: { pending: 0, failed: 1, completed: 2}

  # after_commit -> { CreatePayoutWorker.perform_async(self.id) }, on: :create
end

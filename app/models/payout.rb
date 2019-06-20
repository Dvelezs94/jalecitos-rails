class Payout < ApplicationRecord
  belongs_to :user
  has_many :orders
  enum status: { in_review: 0, pending: 1, failed: 2, completed: 3 } 
end

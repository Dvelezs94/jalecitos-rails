class Withdrawal < ApplicationRecord
  belongs_to :user
  has_many :orders
  enum status: { in_progress: 0, denied: 1, completed: 2}
end

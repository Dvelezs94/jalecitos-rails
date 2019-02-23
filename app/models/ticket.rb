class Ticket < ApplicationRecord
  belongs_to :user
  has_many :ticket_responses
  enum status: { in_progress: 0, resolved: 1}
  enum priority: { low: 0, normal: 1, high: 2}
end

class Ticket < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :user
  has_many :ticket_responses
  enum status: { in_progress: 0, resolved: 1}
  enum priority: { low: 0, normal: 1, high: 2}
  enum turn: { waiting_for_support: 0, waiting_for_user: 1}
end

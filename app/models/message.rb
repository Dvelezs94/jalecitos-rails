class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :body,
    presence: true,
    length: {maximum: 500},
    on: :create
  after_create_commit { MessageBroadcastJob.perform_later(self) }
end

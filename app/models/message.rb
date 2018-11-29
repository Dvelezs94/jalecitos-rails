class Message < ApplicationRecord
  #search
  searchkick language: "spanish"
  #Associations
  belongs_to :user
  belongs_to :conversation
  #Validations
  validates :body,
    presence: true,
    length: {maximum: 500},
    on: :create
  after_create_commit { MessageBroadcastJob.perform_later(self) }
end

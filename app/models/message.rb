class Message < ApplicationRecord
  #search
  searchkick language: "spanish"
  #Associations
  belongs_to :user
  belongs_to :conversation
  #Validations
  validates :body,
    length: {maximum: 500},
    on: :create

  validates_presence_of :body, :unless => :image?
  after_create_commit { MessageBroadcastJob.perform_later(self) }

  mount_uploader :image, MessageUploader
end

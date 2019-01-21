class Message < ApplicationRecord
  #search
  searchkick language: "spanish"

  def search_data
    {
      id: id,
      user_id: user_id,
      conversation_id: conversation_id
     }
  end
  #Associations
  belongs_to :user
  belongs_to :conversation
  #Validations
  validates :body,
    length: {maximum: 500},
    on: :create

  validates_presence_of :body, :unless => :image?
  after_create_commit { [MessageBroadcastWorker.perform_async(self.id),  MessageNotificationWorker.perform_in(10.seconds, self.id)] }

  mount_uploader :image, MessageUploader
end

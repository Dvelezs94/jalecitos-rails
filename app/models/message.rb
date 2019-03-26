class Message < ApplicationRecord
  #search
  # searchkick language: "spanish"
  #
  # def search_data
  #   {
  #     user_id: user_id,
  #     conversation_id: conversation_id
  #    }
  # end
  #Associations
  belongs_to :user
  belongs_to :conversation
  belongs_to :related_to, polymorphic: true, optional: true
  #Validations
  validates :body,
    length: {maximum: 500},
    on: :create
  validate :polymorphic_type, on: :create

  validates_presence_of :body, :unless => :image?
  after_create_commit { [MessageBroadcastWorker.perform_async(self.id),  MessageNotificationWorker.perform_async(self.id), MessageEmailWorker.perform_in(2.minutes, self.id)] }

  # update conversation "updated_at" after a message is created
  after_commit -> {update_conversation(self.conversation)}, on: :create
  mount_uploader :image, MessageUploader

  private
  def update_conversation (conversation)
    conversation.touch
  end

  def polymorphic_type
    if self.related_to_type.present?
      allowed = ["Gig", "Request"]
      if ! allowed.include?(self.related_to_type)
        errors.add(:base, "No se admite este modelo") #this isnt used because message is created by ajax
      end
    end
  end
end

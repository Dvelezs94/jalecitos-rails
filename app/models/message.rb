class Message < ApplicationRecord
  #search
  #callbacks false make sync off so records are not added automatically
   searchkick language: "spanish",callbacks: false
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
    length: {maximum: 1000}, #user can put 500 chars, but in server we have to convert links to tags with text and replace < with &lt: and also > with &gt;
    on: :create
  validate :polymorphic_type, on: :create

  validates_presence_of :body, :unless => :image?
  after_create_commit { [MessageBroadcastWorker.perform_async(self.id),  MessageNotificationWorker.perform_async(self.id), MessageEmailWorker.perform_in(2.minutes, self.id)] }

  # update conversation "updated_at" after a message is created
  after_commit -> {update_conversation(self.conversation)}, on: :create
  mount_uploader :image, MessageUploader

  def body=(val)
    #removes all html coming from user and then replaces the links for a tags (the message partial makes the html_safe)
    write_attribute(:body, make_links(CGI::escapeHTML(val)))
  end
  private
  def update_conversation (conversation)
    conversation.touch
  end
  def make_links val
    regexp = /(https?:\/\/)?\w*\.\w+(\.\w+)*(\/\w+)*(\.\w*)?/
    val.gsub(regexp) { |url| "<a href='#{url}' target='_blank'>#{url}</a>"}
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

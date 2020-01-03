class Message < ApplicationRecord
  include LinksHelper
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
  validates_length_of :body, :maximum => 500, :message => "debe contener como máximo 500 caracteres."
  validate :polymorphic_type, on: :create

  validates_presence_of :body, :unless => :image?
  after_create_commit { [MessageBroadcastWorker.perform_async(self.id),  MessageNotificationWorker.perform_async(self.id), MessageEmailWorker.perform_in(2.minutes, self.id)] }

  # update conversation "updated_at" after a message is created
  after_commit -> {update_conversation(self.conversation)}, on: :create
  mount_uploader :image, MessageUploader

  def safe_body
    make_links(CGI::escapeHTML(self.body)).html_safe #escapes html from user and make our links
  end

  def old_body
    old_body = ActionController::Base.helpers.strip_tags(self.body)
    old_body = CGI::unescapeHTML(old_body)
    old_body
  end
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

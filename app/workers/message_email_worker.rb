class MessageEmailWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include ApplicationHelper
  include Rails.application.routes.url_helpers

  #Message (user, recipient, body, conversation_id)
  def perform(message_id)
    message = Message.includes(:conversation).find(message_id)
    receiver = message.conversation.opposed_user(message.user_id)
    # Check if message has been read already
    if message.read_at?
      # Return true to finish operation if condition is met
      return true
    end
    if receiver.transactional_emails
      MessageMailer.new_message(message, receiver.email).deliver
    else
      return true
    end
  end

end

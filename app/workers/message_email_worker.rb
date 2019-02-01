class MessageEmailWorker
  include Sidekiq::Worker

  include ApplicationHelper
  include Rails.application.routes.url_helpers

  #Message (user, recipient, body, conversation_id)
  def perform(message_id)
    message = Message.find(message_id)
    # Check if message has been read already
    if message.read_at?
      # Return true to finish operation if condition is met
      return true
    end
    MessageMailer.new_message(message).deliver
  end

end

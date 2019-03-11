class MessageNotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  include ApplicationHelper
  include PushFunctions
  include Rails.application.routes.url_helpers

  #Message (user, recipient, body, conversation_id)
  def perform(message_id)
    message = Message.find(message_id)
    # Check if message has been read already
    if message.read_at?
      # Return true to finish operation if condition is met
      return true
    end
    @receiver = opposite_conversation_user(message.conversation, message.user)
    @message = {
     notification: {
        title: "Jalecitos",
        body:  "#{message.user.slug}: #{message.body}",
        icon: "#{avatar_display_helper(message.user.image_url(:thumb))}",
        click_action: conversations_url(:user_id => message.user.slug),
        badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png"
      }
    }
    createFirebasePush(@receiver.id, @message)

  end
end

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
        priority: 'high',
        data: {
            title: "#{message.user.slug}",
            message: "#{message.old_body}"
        },
         notification: {
            title: "#{message.user.slug}",
            body:  "#{message.old_body}",
            icon: "#{avatar_display_helper(message.user.image_url(:thumb))}",
            #click_action: conversations_url(:user_id => message.user.slug),
            tag: "message-#{message.conversation_id}"
          },
          webpush: {
            headers: {
              Urgency: "high"
            }
         }
      }
    createFirebasePush(@receiver.id, @message)

  end
end

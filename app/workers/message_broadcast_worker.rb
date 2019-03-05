class MessageBroadcastWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find(message_id)
    sender = message.user
    recipient = message.conversation.opposed_user(sender)

    broadcast_to_sender(sender, recipient, message)
    broadcast_to_recipient(recipient, sender, message)
  end

  private

  def broadcast_to_sender(user, opposite, message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      message: render_message(message, user),
      conversation_id: message.conversation_id,
      opposite_slug: opposite.slug
    )
  end

  def broadcast_to_recipient(user, opposite, message)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      message: render_message(message, user),
      conversation_id: message.conversation_id,
      opposite_slug: opposite.slug
    )
  end

  def render_message(message, user)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message, user: user }
    )
  end
end

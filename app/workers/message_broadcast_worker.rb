class MessageBroadcastWorker
  include Sidekiq::Worker

  def perform(message_id)
    message = Message.find(message_id)
    sender = message.user
    receiver = message.conversation.opposed_user(sender)
    stuff = {'user' => sender, 'unread_messages' => message.conversation.unread_messages?(receiver) }

    broadcast_to_sender(sender, receiver, message)
    broadcast_to_receiver(receiver, sender, message, stuff)
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

  def broadcast_to_receiver(user, opposite, message, stuff)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      message: render_message(message, user),
      conversation_id: message.conversation_id,
      opposite_slug: opposite.slug,
      conversation_min: render_conversation(stuff)
    )
  end

  def render_message(message, user)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message, user: user }
    )
  end

  def render_conversation(stuff)
    ApplicationController.render(
       partial: "conversations/conversation_min",
       locals: { user: stuff }
    )
  end
end

class MessageBroadcastWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  def perform(message_id)
    message = Message.includes(conversation: [:messages, :recipient, :sender]).find(message_id)
    if message.user_id == message.conversation.recipient_id
      sender = message.conversation.recipient
      receiver = message.conversation.sender
    else
      sender = message.conversation.sender
      receiver = message.conversation.recipient
    end
    s_stuff = {'user' => receiver, 'unread_messages' => message.conversation.unread_messages?(sender) }
    r_stuff = {'user' => sender, 'unread_messages' => message.conversation.unread_messages?(receiver) }
    broadcast_to_sender(sender, receiver, message, s_stuff)
    broadcast_to_receiver(receiver, sender, message, r_stuff) if sender != receiver # if user sends message to himself dont send twice
  end

  private

  def broadcast_to_sender(user, opposite, message, stuff)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      message: render_message(message,user),
      conversation_id: message.conversation_id,
      conversation_min: render_conversation(stuff),
      opposite_id: opposite.id,
      role: "sender"
    )
  end

  def broadcast_to_receiver(user, opposite, message, stuff)
    ActionCable.server.broadcast(
      "conversations-#{user.id}",
      message: render_message(message, opposite),
      message_min: render_message_min(message),
      conversation_id: message.conversation_id,
      opposite_id: opposite.id,
      conversation_min: render_conversation(stuff),
      role: "receiver"
    )
  end

  def render_message(message, user)
    ApplicationController.render(
      partial: 'messages/message',
      locals: { message: message, user: user }
    )
  end
  def render_message_min(message)
    ApplicationController.render(
      partial: 'messages/message_min',
      locals: { message: message }
    )
  end

  def render_conversation(stuff)
    ApplicationController.render(
       partial: "conversations/conversation_min",
       locals: { user: stuff }
    )
  end
end

json.messages ApplicationController.render(
  partial: 'messages/message_min',
  collection: @messages,
  as: "message"
)
json.unread @unread

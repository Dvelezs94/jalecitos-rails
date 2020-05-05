class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications-#{current_user.id}"
    #online users
    ActionCable.server.pubsub.redis_connection_for_subscriptions.sadd "online", current_user.id
  end

  def unsubscribed
    stop_all_streams
    #online users
    ActionCable.server.pubsub.redis_connection_for_subscriptions.srem "online", current_user.id
  end
end

class MessageNotificationWorker
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
    @receiver = opposite_conversation_user(message.conversation, message.user)
    @message = {
      title: "Jalecitos",
      body:  "#{message.user.slug}: #{message.body}",
      badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png",
      icon: avatar_display_helper(message.user.image_url(:thumb)),
      renotify: true,
      tag: "jalecios-message-#{@receiver.slug}",
      openUrl: conversations_path(:user_id => message.user.slug),
      vibrate: [125, 75, 125],
    }

    @vapid = {
      subject: "mailto:noreply@jalecitos.com",
      public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
      private_key: ENV.fetch('VAPID_PRIVATE_KEY')
    }

    #Loop through every subscription to send the push notification
    @receiver.push_subscriptions.each do |subs|
      begin
        Webpush.payload_send(
          endpoint: subs.endpoint,
          message: JSON.generate(@message),
          p256dh: subs.p256dh,
          auth: subs.auth,
          vapid: @vapid
        )
      # If the subscription is gone(deleted), destroy it from DB
      rescue Webpush::InvalidSubscription
        subs.destroy
      rescue Webpush::ExpiredSubscription
        subs.destroy
      end
    end

  end
end

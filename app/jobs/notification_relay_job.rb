class NotificationRelayJob < ApplicationJob
  include ApplicationHelper
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(notification)
    # Create push notification
    @message = {
      title: "Jalecitos",
      body:  "#{notification.user.slug} #{notification.action} #{build_notifiable_type(notification.notifiable)}",
      icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
      badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
      tag: "jalecios",
      openUrl: url_generator_helper(notification, notification.notifiable),
      vibrate: [125, 75, 125],
    }

    @vapid = {
      subject: "mailto:noreply@jalecitos.com",
      public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
      private_key: ENV.fetch('VAPID_PRIVATE_KEY')
    }

    #Loop through every subscription to send the push notification
    notification.recipient.push_subscriptions.each do |subs|
      begin
        Webpush.payload_send(
          endpoint: subs.endpoint,
          message: JSON.generate(@message),
          p256dh: subs.p256dh,
          auth: subs.auth,
          vapid: @vapid
        )
      # If the subscription is gone(deleted), destroy it from DB
      rescue Webpush::InvalidSubscription => e
        subs.destroy
      end
    end

    # Render Website notification
    html = {:fadeItem => ApplicationController.render(partial: "notifications/flash/notification", locals: {notification: notification}, formats: [:html]),
            :listItem => ApplicationController.render(partial: "notifications/notification", locals: {notification: notification})
      }
    ActionCable.server.broadcast "notifications-#{notification.recipient_id}", html: html.to_json
  end
end

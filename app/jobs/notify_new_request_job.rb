class NotifyNewRequestJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(request)
    # check if tags are set
    if (@tags = Request.last.tag_list.to_s) == ""
      return
    end
    @users = User.search @tags, operator: "or", where: {location: request.location}


    #build notification
    @message = {
      title: "Jalecitos",
      body:  "Encontramos un pedido en tu zona que puede interesarte! - Busco a alguien #{request.name}",
      icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
      openUrl: request_path(request.slug),
      vibrate: [125, 75, 125],
    }

    @vapid = {
      subject: "mailto:noreply@jalecitos.com",
      public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
      private_key: ENV.fetch('VAPID_PRIVATE_KEY')
    }
    p "x" * 600
    p @users
    #Loop through every subscription to send the push notification
    @users.each do |user|
      user.push_subscriptions.each do |subs|
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
    end

  end
end

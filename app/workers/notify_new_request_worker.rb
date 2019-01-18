class NotifyNewRequestWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  def perform(request_id)
    request = Request.find(request_id)
    # Users list from gigs professions and location
    @users_gigs = Gig.search(request.profession, where: {location: request.location}, load: false).results.map(&:user_id)

    # Users list from tags list and location
    if (@tags = request.tag_list.to_s) != ""
      @users_tags = User.search(@tags, operator: "or", where: {location: request.location}, load: false).results.map(&:id)
    else
      @users_tags = []
    end

    # Merge both lists with unique users ids
    @users = (@users_gigs + @users_tags).uniq




    #build notification
    @message = {
      title: "Jalecitos",
      body:  "Encontramos un pedido en tu zona que puede interesarte! - #{request.title}",
      icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
      openUrl: request_path(request.slug),
      vibrate: [125, 75, 125],
    }

    @vapid = {
      subject: "mailto:noreply@jalecitos.com",
      public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
      private_key: ENV.fetch('VAPID_PRIVATE_KEY')
    }

    #Loop through every subscription to send the push notification
    @users.each do |user|
      User.find(user).push_subscriptions.each do |subs|
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

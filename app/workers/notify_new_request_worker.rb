class NotifyNewRequestWorker
  include Sidekiq::Worker
  include PushFunctions
  sidekiq_options retry: 2
  include Rails.application.routes.url_helpers

  def perform(request_id)
    request = Request.find(request_id)
    # Users list from gigs professions and location
    @users_gigs = Gig.search(request.profession, where: {city_id: request.city_id}, load: false).results.map(&:user_id)

    # Users list from tags list and location
    if (@tags = request.tag_list.to_s) != ""
      @users_tags = User.search(@tags, operator: "or", where: {city_id: request.city_id}, load: false).results.map(&:id)
    else
      @users_tags = []
    end

    # Merge both lists with unique users ids
    @users = (@users_gigs + @users_tags).uniq

    #build notification
    @message = {
      notification: {
        title: "Jalecitos",
        body:  "Encontramos un pedido en tu zona que puede interesarte! - #{request.title}",
        icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
        click_action: request_path(request.slug),
        badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png"
      }
    }

    #Loop through every subscription to send the push notification
    @users.each do |user|
      createFirebasePush(user, @message)
    end

  end
end

class NotifyNewRequestWorker
  include Sidekiq::Worker
  include PushFunctions
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
      notification: {
        title: "Jalecitos",
        body:  "Encontramos un pedido en tu zona que puede interesarte! - #{request.title}",
        icon: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/favicon.png",
        openUrl: request_path(request.slug)
      }
    }

    #Loop through every subscription to send the push notification
    @users.each do |user|
      createFirebasePush(user.id, @message)
    end

  end
end

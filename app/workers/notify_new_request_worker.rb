class NotifyNewRequestWorker
  include Sidekiq::Worker
  include PushFunctions
  sidekiq_options retry: 2, dead: false
  include Rails.application.routes.url_helpers

  def perform(request_id)
    request = Request.find(request_id)
    #specifications
    specif = request.tag_list.join(" ") +  " " + request.profession
    # Search from gigs
    @gigs = Gig.search(specif, fields: [:tags, :profession], operator: "or", where: {city_id: request.city_id}, load: false, execute: false)
    # Search from users
    @users = User.search(specif, fields: [:tags], operator: "or", where: {city_id: request.city_id}, load: false, execute: false)
    #make search in one request
    Searchkick.multi_search([@gigs, @users])
    #get ids
    @gig_user_ids = @gigs.map(&:user_id)
    @user_ids = @users.map(&:id)
    # Merge both lists with unique users ids
    @notify_to = (@user_ids + @gig_user_ids).uniq
    #dont send to owner
    @notify_to -= [request.user_id]
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
    @notify_to.each do |user_id|
      createFirebasePush(user_id, @message)
    end

  end
end

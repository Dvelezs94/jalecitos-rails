class NotifyNewRequestWorker
  include Sidekiq::Worker
  include PushFunctions
  include ActionView::Helpers::AssetUrlHelper
  sidekiq_options retry: 2, dead: false
  include Rails.application.routes.url_helpers

  def perform(request_id)
    request = Request.find(request_id)
    #specifications
    tag_list = request.tag_list
    specif = tag_list.push(request.profession).collect{|i|  i.gsub(/\s+/, "")}.join(" ") #remove white spaces from tags of more than 1 word, because searchkick matches every word by separate, so the tag "data cleaning" matches with a request of "cleaning house". Now if someone requests with tag "cleaning house" i convert it to "cleaninghouse" and its more difficult to match and now it has to match all the sentence (every white space costs y edit to word so it matches cleaning house)
    if specif.present? #profession or tags
      # Search from gigs
      @gigs = Gig.search(specif, fields: [:tags, :profession], operator: "or", where: { location: { near: {lat: request.lat, lon: request.lng}, within: "200km" } }, load: false, execute: false, misspellings: {prefix_length: 5, edit_distance: 2})
      # Search from users
      @users = User.search(specif, fields: [:tags], operator: "or", where: { location: { near: {lat: request.lat, lon: request.lng}, within: "200km" } }, load: false, execute: false, misspellings: {prefix_length: 5, edit_distance: 2})
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
        priority: 'high',
        data: {
            title: "Wand",
            message: "¡Encontramos un pedido que puede interesarte! - #{request.title}"
        },
        notification: {
          title: "Wand",
          body:  "¡Encontramos un pedido que puede interesarte! - #{request.title}",
          icon: image_url("favicon.ico"),
          click_action: request_path(request.slug),
          badge: image_url("favicon.ico")
        },
        webpush: {
          headers: {
            Urgency: "high"
          }
       }
      }

      #Loop through every subscription to send the push notification
      @notify_to.each do |user_id|
        RequestMailer.new_request(user_id, request).deliver if User.find(user_id).transactional_emails
        createFirebasePush(user_id, @message)
        # Send email if transactional emails are enabled
      end

    end
  end
end

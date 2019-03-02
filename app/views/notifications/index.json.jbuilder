json.array! @notifications do |notification|
  json.id notification.id
  json.user do
    json.slug notification.user.slug
    json.image_url notification.user.image_url
  end
  json.action notification.action
  # Build the url depending on the notifiable type
  json.redirect do
      json.path url_generator_helper(notification, notification.notifiable)
    end

  # Build the message depending on the notifiable type
  json.notifiable do
    json.type build_notification_text(notification, notification.notifiable)
  end
  json.date distance_of_time_in_words_to_now(notification.created_at)
  json.seen notification.read_at?
end

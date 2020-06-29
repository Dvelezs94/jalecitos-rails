json.array! @notifications do |notification|
  json.id notification.id
  json.user do
    json.slug notification.user.slug
    json.image_url avatar_display_helper(notification.user.image_url)
  end
  json.action notification.action
  # Build the url depending on the notifiable type
  json.redirect do
      json.path url_generator_helper(notification, notification.notifiable)
    end

  # Build the message depending on the notifiable type
  json.text json.type build_notification_text(notification, notification.notifiable)

  json.date notification.created_at.strftime("%b %e, %I:%M %P")
  json.seen notification.read_at?
end


json.array! @notifications do |notification|
  json.id notification.id
  json.user do
    json.slug notification.user.slug
    json.image_url notification.user.image_url
  end
  json.action notification.action
  # Build the url depending on the notifiable type
  json.redirect do
    case
    when notification.notifiable_type == "Request"
      json.path request_path(notification.notifiable.slug)
    when notification.notifiable_type == "Gig"
      json.path user_gig_path(notification.user, notification.notifiable.slug)
    end
  end
  # Build the message depending on the notifiable type
  json.notifiable do
    case
    when notification.notifiable_type == "Request"
      json.type "en tu pedido #{notification.notifiable.name}"
    when notification.notifiable_type == "Gig"
      json.type "en tu jale #{notification.notifiable.name}"
    end
  end
  json.date notification.created_at
end

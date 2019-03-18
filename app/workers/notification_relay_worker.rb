class NotificationRelayWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2, dead: false
  include ApplicationHelper
  include PushFunctions
  include Rails.application.routes.url_helpers

  def perform(notification_id, review_id)
    notification = Notification.find(notification_id)

    # Create push notification
    @message = {
      notification: {
        title: "Jalecitos",
        body:  build_notification_text(notification, notification.notifiable, false),
        icon: avatar_display_helper(notification.user.image_url(:thumb)),
        click_action: url_generator_helper(notification, notification.notifiable),
        badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png"
      },
      webpush: {
        headers: {
          Urgency: "high"
        }
     }
    }

    createFirebasePush(notification.recipient_id, @message)

    # Render Website notification
    html = {:fadeItem => ApplicationController.render(partial: "notifications/flash/notification", locals: {notification: notification}, formats: [:html]),
            :listItem => ApplicationController.render(partial: "notifications/notification", locals: {notification: notification})
      }
    #if its present i have to check if its still pending
    if review_id.present?
      review = Review.find(review_id)
      #if its pending, i have to pass the review modal to the employee
      if review.pending?
        #act like a normal request of giver
        renderer = ApplicationController.renderer_with_signed_in_user(review.giver)
        #now load the modal
        html = html.merge(:reviewItem => renderer.render(partial: 'reviews/review', locals: { review: review }, formats: [:html]) )
      end
    end
    ActionCable.server.broadcast "notifications-#{notification.recipient_id}", html: html.to_json
  end
end

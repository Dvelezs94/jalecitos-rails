class RunMarketingNotificationsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  include PushFunctions
  include FilterMarketingCampaign

  def perform()
    @marketing_notifications = MarketingNotification.pending

    @marketing_notifications.each do |mn|
      @message = {
        priority: 'high',
        data: {
            title: mn.name,
            message: mn.content
        },
        notification: {
          title: mn.name,
          body:  mn.content,
          #click_action: (mn.url || "/"),
          #badge: "https://s3.us-east-2.amazonaws.com/cdn.jalecitos.com/images/Logo_Jalecitos-01.png"
        },
        webpush: {
          headers: {
            Urgency: "high"
          }
       }
      }
      # check if the notification is valid or not
      if mn.scheduled_at.future?
        break
      end

      begin
        p "running campaign: #{mn.name}"
        mn.running!
        get_users(mn.filters).each do |user|
          p "sending campaign to: #{user.email}"
          createFirebasePush(user.id, @message)
        end
      rescue => e
        Bugsnag.notify(e)
        mn.failed!
      end
      mn.finished!
    end
  end
end

class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :subscribe_params, only: [:subscribe]
  skip_before_action :verify_authenticity_token

  def index
    @notifications = Notification.where(recipient: current_user).order(id: :desc)
  end

  def mark_as_read
    @unread_notifications = Notification.where(recipient: current_user).where(read_at: nil)
    if @unread_notifications.count > 0
      @unread_notifications.update_all(read_at: Time.zone.now)
    end
    render json: {success: true}
  end

  # create push notification
  # def push
  #
  #   message = {
  #     title: "title",
  #     body: "body",
  #     icon: "http://example.com/icon.pn"
  #   }
  #   Webpush.payload_send(
  #   message: JSON.generate(message),
  #   endpoint: params[:subscription][:endpoint],
  #   p256dh: params[:subscription][:keys][:p256dh],
  #   auth: params[:subscription][:keys][:auth],
  #   vapid: {
  #     subject: "mailto:sender@example.com",
  #     public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
  #     private_key: ENV.fetch('VAPID_PRIVATE_KEY')
  #   },
  #     ssl_timeout: 5, # value for Net::HTTP#ssl_timeout=, optional
  #     open_timeout: 5, # value for Net::HTTP#open_timeout=, optional
  #     read_timeout: 5 # value for Net::HTTP#read_timeout=, optional
  #   )
  # end

  def subscribe
    @subscription = PushSubscription.new(subscribe_params)
    @subscription.user = current_user
    if @subscription.save
      render json: { message: "Added subscription" }, status: :ok
    else
      render json: { message: "Failure when adding subscription" }, status: :not_implemented
    end
  end

  private

  def subscribe_params
    subscribe_params = params.permit(:endpoint, :keys => [:auth, :p256dh])
    subscribe_params[:keys].merge(endpoint: subscribe_params[:endpoint])
  end

end

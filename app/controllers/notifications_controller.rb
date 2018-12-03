class NotificationsController < ApplicationController
  layout 'logged'
  before_action :authenticate_user!
  before_action :subscribe_params, only: [:subscribe, :drop_subscribe]
  skip_before_action :verify_authenticity_token

  def index
    @notifications = Notification.search("*", where:{recipient_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], includes: [:user, :notifiable], limit: 15)
  end

  def all
    @notifications = Notification.search("*", where:{recipient_id: current_user.id}, order: {created_at: :desc}, page: params[:page], per_page: 20)
  end

  def mark_as_read
    @unread_notifications = Notification.search("*", where:{recipient_id: current_user.id, read_at: nil})
    if @unread_notifications.count > 0
      @unread_notifications.each do |notification|
        notification.update(read_at: Time.zone.now)
      end
    end
    render json: {success: true}
  end

  def subscribe
    @subscription = PushSubscription.new(subscribe_params)
    @subscription.user = current_user
    if @subscription.save
      render json: { message: "Added subscription" }, status: :ok
    else
      render json: { message: "Failure when adding subscription" }, status: :not_implemented
    end
  end

  def drop_subscribe
    @subscription = subscribe_params[:auth]
    if current_user.push_subscriptions.find_by_auth(@subscription).destroy
      render json: { message: "Removed subscription" }, status: :ok
    else
      render json: { message: "Failure when removing subscription" }, status: :not_implemented
    end
  end

  private

  def subscribe_params
    subscribe_params = params.permit(:endpoint, :keys => [:auth, :p256dh])
    subscribe_params[:keys].merge(endpoint: subscribe_params[:endpoint])
  end

end

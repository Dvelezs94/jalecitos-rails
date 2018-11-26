class NotificationsController < ApplicationController
  before_action :authenticate_user!
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

end

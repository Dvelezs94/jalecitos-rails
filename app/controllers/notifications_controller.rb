class NotificationsController < ApplicationController
  layout 'logged'
  before_action :authenticate_user!
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

end

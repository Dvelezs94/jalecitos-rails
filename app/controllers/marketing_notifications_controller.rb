class MarketingNotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_marketing_notification, only: [:destroy]
  access admin: :all

  # POST /likes
  def create
    @marketing_notification = MarketingNotification.new(marketing_notification_params)
    begin
      @marketing_notification.save
      flash[:success] = "Se creo la notificacion: #{@marketing_notification.name} para la fecha: #{@marketing_notification.scheduled_at}"
    rescue => e
      flash[:error] = "Error #{e}"
    end
    redirect_to marketing_notifications_admins_path
  end

  def destroy
    if @marketing_notification.cancelled!
      flash[:success] = "La notificacion ha sido cancelada"
    else
      flash[:error] = "Error al actualizar notificacion"
    end
    redirect_to marketing_notifications_admins_path
  end

  private
    def marketing_notification_params
      marketing_params = params.require(:marketing_notification).permit(:name, :content, :url, :scheduled_at, :filters)
      marketing_params[:filters] = eval(marketing_params[:filters])
      marketing_params
    end

    def set_marketing_notification
      @marketing_notification = MarketingNotification.find(params[:id])
    end
end

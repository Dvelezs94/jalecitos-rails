class MobilesController < ApplicationController
  layout "mobile"
  access all: :all
  before_action :set_fcm_cookie
  before_action :verify_logged
  before_action :set_mb_cookie

  def log_in
    render "users/sessions/new"
  end

  def register
    render "users/registrations/new"
  end

  private

  def verify_logged
    if user_signed_in?
      redirect_to root_path #default root path on mobile
    end
  end

  def set_mb_cookie
    # cookie to know if the user is signing in from a mobile
    cookies.permanent.signed[:mb] = rand
  end

  # this is the token from android, to handle and save the cookie for future notifications
  def set_fcm_cookie
    cookies.permanent[:FcmToken] = params[:fcmtoken] if params[:fcmtoken].present?
  end
end

class MobilesController < ApplicationController
  layout "mobile"
  access all: :all
  before_action :verify_logged
  before_action :set_mb_cookie

  def log_in
  end

  def register
  end

  private

  def verify_logged
    if user_signed_in?
      redirect_to root_path(review: "true")
    end
  end

  def set_mb_cookie
    # cookie to know if the user is signing in from a mobile
    cookies.permanent.signed[:mb] = rand
  end
end

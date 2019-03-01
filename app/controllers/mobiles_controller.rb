class MobilesController < ApplicationController
  layout "mobile"
  access all: :all
  before_action :verify_logged

  def sign_in
    # cookie to know if the user is signing in from a mobile
    cookies.permanent.signed[:mb] = rand
  end

  def sign_up
  end

  private

  def verify_logged
    if user_signed_in?
      redirect_to root_path(review: "true")
    end
  end
end

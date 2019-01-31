class MobilesController < ApplicationController
  layout "mobile"
  access all: :all
  before_action :verify_logged

  def sign_in
  end

  def sign_up
  end

  private

  def verify_logged
    if user_signed_in?
      redirect_to root_path
    end
  end
end

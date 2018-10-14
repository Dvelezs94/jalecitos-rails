class PagesController < ApplicationController
  before_action :admin_redirect, only: :home
  def home
    if current_user && current_user.has_role?(:user)
      @gigs = Gig.where(status: "published").where.not(user_id: current_user.id)
    end
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(:controller => 'admins', :action => 'dashboard') : nil
  end

end

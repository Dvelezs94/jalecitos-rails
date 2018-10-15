class PagesController < ApplicationController
  layout 'page'
  before_action :admin_redirect, only: :home
  def home
    if current_user && current_user.has_role?(:user)
      @gigs = Gig.friendly.where(status: "published").where.not(user_id: current_user.id)
    end
  end

  def requests_index
    @requests = Request.friendly.order(created_at: :desc)
    render "requests"
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(:controller => 'admins', :action => 'dashboard') : nil
  end

end

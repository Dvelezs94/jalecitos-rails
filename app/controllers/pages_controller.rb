class PagesController < ApplicationController
  layout 'page'
  before_action :admin_redirect, only: :home
  def home
    if current_user && current_user.has_role?(:user)
      @verified_gigs = Gig.includes(:user, :packages).where(status: "published",category: 1).where.not(user_id: current_user.id).first(5)
      @recommended_gigs = Gig.includes(:user, :packages).published.where.not(user_id: current_user.id).where(category: 2).first(5)
      @featured_gigs = Gig.includes(:user, :packages).published.where.not(user_id: current_user.id).where(category: 3).first(5)
    end
  end

  def requests_index
    @requests = Request.includes(:user).friendly.order(created_at: :desc)
    render "requests"
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(:controller => 'admins', :action => 'dashboard') : nil
  end


end

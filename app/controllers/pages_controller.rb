class PagesController < ApplicationController
  def home
    # Info for admin Dashboard
    if current_user && current_user.has_role?(:admin)
      @gigs = Gig.order(status: :desc).page(params[:gig_page]).per(25)
      @categories =  Category.order(:name).page(params[:category_page]).per(10)
    elsif current_user && current_user.has_role?(:user)
      @gigs = Gig.where.not(user_id: current_user.id, status: "published")
    end
  end
end

class PagesController < ApplicationController
  def home
    # Info for admin Dashboard
    if current_user && current_user.has_role?(:admin)
      @gigs = Gig.all
      @categories = Category.all
    elsif current_user && current_user.has_role?(:user)
      @gigs = Gig.where.not(user_id: current_user.id, status: "published")
    end
  end
end

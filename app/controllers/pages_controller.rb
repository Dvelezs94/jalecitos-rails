class PagesController < ApplicationController
  def home
    if current_user
      @gigs = Gig.where.not(user_id: current_user.id)
    end
  end
end

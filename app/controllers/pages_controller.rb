class PagesController < ApplicationController
  def index
    if current_user
      @gigs = Gig.where.not(user_id: current_user.id)
    end
  end
end

module GetGig
  private
  def get_related_gigs bool=false
    @show_x_related_gigs = 4 #user in view to display "see more" if the is more
    @related_gigs = Gig.search("*",
       includes: [:likes, :category, :user],
        where: {status: "published", category_id: @gig.category_id},
        boost_by: {score: {factor: 100}},
         boost_by_distance: {location: {origin: {lat: @gig.lat, lon: @gig.lng}, function: "exp", factor: 50}},
         limit: @show_x_related_gigs, execute: bool, operator: "or", misspellings: misspellings, order: {})
  end

  def get_reviews
    #get the associated reviews that doesnt belong to gig owner
    if current_user
      @reviews = @gig.completed_reviews.
      where.not(giver_id: current_user.id).
      page(params[:reviews]).per(5)
    else #is guest
      @reviews = @gig.completed_reviews.
      page(params[:reviews]).per(5)
    end
  end

  def get_my_reviews
    #get the associated reviews that belongs to gig owner
    @my_reviews = @gig.completed_reviews.
    where( giver_id: current_user.id )
  end
end

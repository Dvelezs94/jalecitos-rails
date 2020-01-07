module GetGig
  private
  def get_related_gigs bool=false
    @related_gigs = Gig.search("*",
       includes: [:user, :related_pack,
          :likes, city: [state: :country]],
           where: { category_id: @gig.category_id, status: "published",
            _id: { not: @gig.id },
            _or: [{city_id: @gig.city_id}, {city_id: nil}]
           },
            page: params[:related_gigs], per_page: 10, execute: bool)
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

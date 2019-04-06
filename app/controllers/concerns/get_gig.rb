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
    @reviews = Review.includes(:giver, :gig_rating).
    where(reviewable_id: @gig.id, reviewable_type: "Gig", receiver_id: @gig.user.id, status: "completed").order(updated_at: :desc).
    page(params[:reviews]).per(5)
  end
end

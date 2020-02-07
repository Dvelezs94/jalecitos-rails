module GetQuery
  private

  def get_gig query, bool=false
    @gigs = Gig.search(query,
       includes: [:likes, :category, :user, city: [state: :country]],
        where: where_filter, page: params[:gigs],
        boost_by: {score: {factor: 100}},
         boost_by_distance: boost_by_distance_condition,
         per_page: 20, execute: bool, operator: "or", misspellings: misspellings)
  end

  def get_request query, bool=false
    @requests = Request.search(query,
       includes: [:offers, city: [state: :country]],
        where: where_filter, page: params[:requests],
        boost_by_distance: boost_by_distance_condition,
         per_page: 20,
          execute: bool, operator: "or", misspellings: misspellings)
  end

  def misspellings
    #prefix_length : words of n letters or less doesnt have misspellings
    #below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
    #edit_distance : intertions, deletions of sustitutions to match words
    {prefix_length: 3, below: 20, edit_distance: 2}
  end

  def boost_by_distance_condition #other in home
    if current_user.lat
      {location: {origin: {lat: current_user.lat, lon: current_user.lng}, function: "exp"}}
    else #user doesnt has a place of search
      {}
    end
  end

  def by_score
    [{ score: { order: :desc, unmapped_type: :long}}]
  end

end

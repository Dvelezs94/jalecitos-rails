module GetQuery
  private

  def get_gig query, bool=false
    @gigs = Gig.search(query,
       includes: [:likes, :category, :user, city: [state: :country]],
        where: where_filter, page: params[:gigs],
         boost_where: boost_where_condition, boost_by: {score: {factor: 100}},
         per_page: 20, execute: bool, operator: "or", misspellings: misspellings)
  end

  def get_request query, bool=false
    @requests = Request.search(query,
       includes: [:offers, city: [state: :country]],
        where: where_filter, page: params[:requests],
        boost_where: boost_where_condition,
         per_page: 20,
          execute: bool, operator: "or", misspellings: misspellings)
  end

  def misspellings
    #prefix_length : words of n letters or less doesnt have misspellings
    #below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
    #edit_distance : intertions, deletions of sustitutions to match words
    {prefix_length: 3, below: 20, edit_distance: 3}
  end

  def boost_where_condition
    if @city.present?
      {city_id: {value: @city.id, factor: 5}}
    else #no city so i cant boost "Any place of Mexico"
      {}
    end
  end

  def by_score
    [{ score: { order: :desc, unmapped_type: :long}}]
  end

end

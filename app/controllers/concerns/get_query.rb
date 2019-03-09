module GetQuery
  private
  def get_guest_gig bool=false
    @gigs = Gig.search(filter_query,
       includes: [:query_pack, :likes, :user, city: [state: :country]],
        where: guest_where_filter,
        order: by_score,
         page: params[:gigs], per_page: 20,
          execute: bool, operator: "or", misspellings: misspellings)
  end

  def get_guest_request bool=false
    @requests = Request.search(filter_query,
       includes: [:offers, city: [state: :country]],
        where: guest_where_filter, page: params[:requests], per_page: 20,
        execute: bool, operator: "or", misspellings: misspellings)
  end

  def get_user_gig bool=false
    @gigs = Gig.search(filter_query,
       includes: [:query_pack, :likes, :user, city: [state: :country]],
        where: user_where_filter, page: params[:gigs],
        order: by_score,
         per_page: 20, execute: bool, operator: "or", misspellings: misspellings)
  end

  def get_user_request bool=false
    @requests = Request.search(filter_query,
       includes: [:offers, city: [state: :country]],
        where: user_where_filter,
         page: params[:requests], per_page: 20,
          execute: bool, operator: "or", misspellings: misspellings)
  end

  def misspellings
    #prefix_length : words of n letters or less doesnt have misspellings
    #below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
    #edit_distance : intertions, deletions of sustitutions to match words
    {prefix_length: 3, below: 20, edit_distance: 3}
  end

  def by_score
    [{ score: { order: :desc, unmapped_type: :long}}]
  end

end

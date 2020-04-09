module GetQuery
  private

  def get_gig query, bool=false
    @gigs = Gig.search(query,
       includes: [:likes, :category, :user],
        where: where_filter, page: params[:gigs],
        boost_by: boost_by_score,
         boost_by_distance: boost_by_distance_condition,
         per_page: 20, execute: bool, operator: "or", misspellings: misspellings, order: order_by)
  end

  def get_request query, bool=false
    @requests = Request.search(query,
       includes: [:offers, city: [state: :country]],
        where: where_filter, page: params[:requests],
        boost_by_distance: boost_by_distance_condition,
         per_page: 20,
          execute: bool, operator: "or", misspellings: misspellings, order: order_by)
  end
end

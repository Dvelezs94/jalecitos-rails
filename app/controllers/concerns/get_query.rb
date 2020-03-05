module GetQuery
  private

  def get_gig query, bool=false
    @gigs = Gig.search(query,
       includes: [:likes, :category, :user],
        where: where_filter, page: params[:gigs],
        boost_by: boost_by_score,
         boost_by_distance: boost_by_distance_condition,
         per_page: 5, execute: bool, operator: "or", misspellings: misspellings, order: order_by)
  end

  def get_request query, bool=false
    @requests = Request.search(query,
       includes: [:offers, city: [state: :country]],
        where: where_filter, page: params[:requests],
        boost_by_distance: boost_by_distance_condition,
         per_page: 5,
          execute: bool, operator: "or", misspellings: misspellings, order: order_by)
  end

  def misspellings
    #prefix_length : words of n letters or less doesnt have misspellings
    #below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
    #edit_distance : intertions, deletions of sustitutions to match words
    {prefix_length: 3, below: 20, edit_distance: 2}
  end

  def boost_by_distance_condition #other in home
    dist={}
    if params[:lat].present? #guest or user with location
      dist = dist.merge({location: {origin: {lat: params[:lat], lon: params[:lng]}, function: "exp", factor: 50}})
    elsif current_user && current_user.lat # first search when filter isnt there
      dist = dist.merge({location: {origin: {lat: current_user.lat, lon: current_user.lng}, function: "exp", factor: 50}})
    else #get location by ip
      begin
        @userinfo = Geokit::Geocoders::MultiGeocoder.geocode(request.ip)
        dist = dist.merge({location: {origin: {lat: @userinfo.lat, lon: @userinfo.lng}, function: "exp", factor: 50}})
      rescue
        #do nothing, maybe i can put a default location
      end
    end
    return dist
  end

  def by_score
    [{ score: { order: :desc, unmapped_type: :long}}]
  end

  def where_filter
    cond = {status: "published"}
    cond = cond.merge({category_id: params[:category_id]}) if params[:category_id].present?
    cond = cond.merge({price: price_range})
    return cond
  end

  def price_range
    range = {}
    range = range.merge({gte: params[:min_price]}) if params[:min_price].present?
    range = range.merge({lte: params[:max_price]}) if params[:max_price].present?
    return range
  end

  def boost_by_score
    boost ={}
    boost = boost.merge({score: {factor: 100}}) #useful when no order selected
    return boost
  end

  def order_by
    o = {}
    o = o.merge({score: :desc}) if params[:order_by] == "score"
    o = o.merge({price: :asc}) if params[:order_by] == "price"
    o = o.merge({created_at: :desc}) if params[:order_by] == "recent"
    return o
  end
end

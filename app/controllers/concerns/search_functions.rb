module SearchFunctions
  include FilterRestrictions

  private

  # def search model, includes, status
  #   query = filter_query
  #   model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  # end

  def filter_query
    # if query doesnt have nothing search for all
    return '*' if params[:query] == ''

    remove_nexus(no_special_chars(RemoveEmoji::Sanitize.call(params[:query]).downcase))
  end

  def misspellings
    # prefix_length : words of n letters or less doesnt have misspellings
    # below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
    # edit_distance : intertions, deletions of sustitutions to match words
    { prefix_length: 3, below: 20, edit_distance: 2 }
  end

  def boost_by_distance_condition # other in home
    dist = {}
    if params[:lat].present? # guest or user with location
      dist = dist.merge(location: { origin: { lat: params[:lat], lon: params[:lng] }, function: 'exp', factor: 50 })
    elsif current_user && current_user.lat # first search when filter isnt there
      dist = dist.merge(location: { origin: { lat: current_user.lat, lon: current_user.lng }, function: 'exp', factor: 50 })
    else # get location by ip
      begin
        @userinfo = Geokit::Geocoders::MultiGeocoder.geocode(request.ip)
        dist = dist.merge(location: { origin: { lat: @userinfo.lat, lon: @userinfo.lng }, function: 'exp', factor: 50 }) if @userinfo.lat && @userinfo.lng
      rescue
        # do nothing, maybe i can put a default location
      end
    end
    dist
  end

  def by_score
    [{ score: { order: :desc, unmapped_type: :long } }]
  end

  def where_filter
    cond = { status: 'published' }
    cond = cond.merge(category_id: params[:category_id]) if params[:category_id].present?
    cond = cond.merge(price: price_range)
    cond
  end

  def price_range
    range = {}
    range = range.merge(gte: params[:min_price]) if params[:min_price].present?
    range = range.merge(lte: params[:max_price]) if params[:max_price].present?
    range
  end

  def boost_by_score
    boost = {}
    boost = boost.merge(score: { factor: 100 }) # useful when no order selected
    boost
  end

  def order_by
    o = {}
    o = o.merge(score: :desc) if params[:order_by] == 'score'
    o = o.merge(price: :asc) if params[:order_by] == 'price'
    o = o.merge(created_at: :desc) if params[:order_by] == 'recent'
    o
  end
end

module SearchFunctions
  private

  def search model, includes, status
    query = filter_query
    model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  end

  def user_where_filter
    if params[:category_id] != "" && params[:city_id] != ""
      {status: "published", category_id: params[:category_id], _or: [{city_id: params[:city_id]}, {city_id: nil}]}
    elsif params[:category_id] != ""
      {status: "published", category_id: params[:category_id]}
    elsif  params[:city_id] != ""
      {status: "published", _or: [{city_id: params[:city_id]}, {city_id: nil}]}
    else
      {status: "published"}
    end
  end

  def guest_where_filter
    if params[:lon] != "" && params[:lat] != ""
      begin
        loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{params[:lat]},#{params[:lon]}"
        city_id = get_city_id_in_db(loc.city, loc.state_name, "MX")
        {status: "published", _or: [{city_id: city_id}, {city_id: nil}]}
      rescue
        {status: "published"}
      end
    else
      {status: "published"}
    end
  end

  def filter_query
    query = params[:query]
    #if query doesnt have nothing search for all
    query = "*" if ( query == "" )
    #if query has "Ofrezco" at the beginning, cut it (^ represents at the beginning and "i" is case insensitive)
    query = query.sub(/^ofrezco /i, '')
    #same with requests...
    query = query.sub(/^busco un /i, '')
  end

end

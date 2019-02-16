module SearchFunctions
  private

  def search model, includes, status
    query = filter_query
    model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  end

  def user_where_filter
    if params[:category_id] != "" && params[:city_id] != ""
      {status: "published", category_id: params[:category_id], city_id: params[:city_id]}
    elsif params[:category_id] != ""
      {status: "published", category_id: params[:category_id]}
    elsif  params[:city_id] != ""
      {status: "published", city_id: params[:city_id]}
    else
      {status: "published"}
    end
  end

  def guest_where_filter
    if params[:lon] != "" && params[:lat] != ""
      city_id = geoloc_to_city(params[:lat], params[:lon])
      {status: "published", city_id: city_id}
    else
      {status: "published"}
    end
  end

  def filter_query
    query = params[:query]
    #if query doesnt have nothing search for all
    query = "*" if ( query == "" )
    #if query has "Voy a" at the beginning, cut it (^ represents at the beginning and "i" is case insensitive)
    query = query.sub(/^voy a /i, '')
    #same with requests...
    query = query.sub(/^busco un /i, '')
  end

end

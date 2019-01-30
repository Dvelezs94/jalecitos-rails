module SearchFunctions
  private

  def search model, includes, status
    query = filter_query
    model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  end

  def where_filter status
    if params[:category_id] != "" && params[:location] != ""
      {status: status, category_id: params[:category_id], location: params[:location]}
    elsif params[:category_id] != ""
      {status: status, category_id: params[:category_id]}
    elsif  params[:location] != ""
      {status: status, location: params[:location]}
    else
      {status: status}
    end
  end

  def filter_query
    query = params[:query]
    #if query doesnt have nothing search for all
    query = "*" if ( query == "" )
    #if query has "Voy a" at the beginning, cut it
    query = ( query.start_with?("voy a", "Voy a") )? query.sub(/^Voy a /, '').sub(/^voy a /, '') : query
    #same with requests...
    query = ( query.start_with?("busco un", "Busco un") )? query.sub(/^Busco un /, '').sub(/^busco un /, '') : query
  end

  def init_search_options
    filters = Hash.new
    if (params[:model_name] == "requests")
      filters[:includes] = [:user]
      filters[:status] = "open"
      filters[:model] = Request
    else
      filters[:includes] = [:search_gigs_packages, :user]
      filters[:status] = "published"
      filters[:model] = Gig
    end
    return filters
  end

  def pre_text model
    ( model == Gig)? "Voy a " : "Busco un "
  end
end

module SearchFunctions
  private

  # def search model, includes, status
  #   query = filter_query
  #   model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  # end

  def where_filter
    if params[:category_id].present? && @state.present?
      {status: "published", category_id: params[:category_id], _or: [{state_id: @state.id}, {state_id: nil}]}
    elsif params[:category_id].present?
      {status: "published", category_id: params[:category_id]}
    elsif @state.present?
      {status: "published", _or: [{state_id: @state.id}, {state_id: nil}]}
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

module SearchFunctions
  include FilterRestrictions
  private

  # def search model, includes, status
  #   query = filter_query
  #   model.search query,includes: includes, where: where_filter(status), page: params[:page], per_page: 20, match: :word_start
  # end

  def filter_query
    #if query doesnt have nothing search for all
    return "*" if ( params[:query] == "")
    remove_nexus(no_special_chars(RemoveEmoji::Sanitize.call(params[:query]).downcase))
  end

end

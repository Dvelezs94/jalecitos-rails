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


    def misspellings
      #prefix_length : words of n letters or less doesnt have misspellings
      #below : if the results are lower than 20, misspellings are activated (default is 1 edit_distance, but with this word have to match exactly)
      #edit_distance : intertions, deletions of sustitutions to match words
      {prefix_length: 3, below: 20, edit_distance: 2}
    end

end

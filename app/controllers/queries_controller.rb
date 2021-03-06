class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  include GetQuery
  access user: [:autocomplete_profession, :user_mobile_search], admin: :all, all: [:search, :autocomplete_search]
  before_action :check_query, only: :search
  layout :set_layout

  def search
    query = filter_query
    if params[:model_name] == "requests"
      get_request(query, true)
    else
      get_gig(query, true)
    end
    render template: "queries/search_results"
  end

  def autocomplete_search
    render json: Searchkick.search(filter_query, {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession, :tags],
      where:  { status: "published" }
    }).suggestions
  end

  def autocomplete_profession
    query = params[:query]
    #init the filter params
    render json: Profession.search(query, {
      fields: ["name"],
      match: :word_start,
      limit: 10,
      misspellings: {below: 2}
    }).map(&:name)
  end
  private
  def check_query
    redirect_to root_path if params[:query].nil?
  end
end

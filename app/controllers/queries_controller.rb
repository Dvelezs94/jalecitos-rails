class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  include GetQuery
  layout :set_layout
  before_action :set_state, only: [:search]
  access user: [:autocomplete_profession, :user_mobile_search], admin: :all, all: [:search, :autocomplete_search, :autocomplete_location]

  def search
    if params[:gigs]
      get_gig(true)
    elsif params[:requests]
      get_request(true)
    else
      get_gig
      get_request
      Searchkick.multi_search([@gigs, @requests])
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

  def autocomplete_location
    query = params[:query]
    #init the filter params
    @cities = City.search(query, {
      includes: [state: :country],
      fields: ["name"],
      match: :word_start,
      limit: 10,
      misspellings: {below: 2}
    }).map do |city|
      { :location => "#{city.name}, #{city.state.name}, #{city.state.country.name}", :id => city.id }
    end
    render json: @cities

  end

  def user_mobile_search

  end
  private

  def set_state
    if params[:city_id].present?
      get_city_and_state_in_db_by_city_id(params[:city_id])
    elsif params[:lon].present? && params[:lat].present?
      begin
        loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{params[:lat]},#{params[:lon]}"
        get_city_and_state_in_db(loc.city, loc.state_name, "MX") #this makes global variables for using
      rescue
        #nothing
      end
    elsif params[:city].present? && params[:state].present? #used in sitemap (i think so)
        get_city_and_state_in_db(params[:city], params[:state], "MX") #this makes global variables for using
    end
  end
end

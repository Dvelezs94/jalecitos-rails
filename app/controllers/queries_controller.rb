class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  include GetQuery
  layout :set_layout
  before_action :user_set_state, only: [:user_search]
  before_action :guest_set_state, only: [:guest_search]
  access user: [:user_search, :user_autocomplete_search, :autocomplete_profession, :user_mobile_search], admin: :all, all: [:guest_search, :guest_autocomplete_search, :autocomplete_location]

  def guest_search
    if params[:gigs]
      get_guest_gig(true)
    elsif params[:requests]
      get_guest_request(true)
    else
      get_guest_gig
      get_guest_request
      Searchkick.multi_search([@gigs, @requests])
    end
    render template: "queries/search_results"
  end


  def guest_autocomplete_search
    render json: Searchkick.search(params[:query], {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession, :tags],
      where:  { status: "published" }
    }).suggestions
  end

  def user_search
    if params[:gigs]
      get_user_gig(true)
    elsif params[:requests]
      get_user_request(true)
    else
      get_user_gig
      get_user_request
      Searchkick.multi_search([@gigs, @requests])
    end
    render template: "queries/search_results"
  end

  def user_autocomplete_search
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
  def user_set_state
    @state_id = City.find(params[:city_id]).state_id if params[:city_id] != ""
  end

  def guest_set_state
    if params[:lon] != "" && params[:lat] != ""
      begin
        loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{params[:lat]},#{params[:lon]}"
        get_city_and_state_in_db(loc.city, loc.state_name, "MX") #this makes global variables for using
      rescue
        #nothing
      end
    end
  end
end

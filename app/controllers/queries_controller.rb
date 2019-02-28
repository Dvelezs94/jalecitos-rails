class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  layout :set_layout
  access user: [:user_search, :user_autocomplete_search, :autocomplete_profession, :user_mobile_search], admin: :all, all: [:guest_search, :guest_autocomplete_search, :autocomplete_location]

  def guest_search
    if params[:gigs]
      @gigs = Gig.search(filter_query, where: guest_where_filter, page: params[:gigs], per_page: 20, operator: "or")
    elsif params[:requests]
      @requests = Request.search(filter_query, where: guest_where_filter, page: params[:requests], per_page: 20, operator: "or")
    else
      @gigs = Gig.search(filter_query, where: guest_where_filter, execute: false, page: params[:gigs], per_page: 20, operator: "or")
      @requests = Request.search(filter_query, where: guest_where_filter, execute: false, page: params[:requests], per_page: 20, operator: "or")
      Searchkick.multi_search([@gigs, @requests])
    end
    render template: "queries/search_results"
  end


  def guest_autocomplete_search
    render json: Searchkick.search(params[:query], {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession],
      where:  { status: "published" }
    }).suggestions
  end

  def user_search
    if params[:gigs]
      @gigs = Gig.search(filter_query, where: user_where_filter, page: params[:gigs], per_page: 20, operator: "or")
    elsif params[:requests]
      @requests = Request.search(filter_query, where: user_where_filter, page: params[:requests], per_page: 20, operator: "or")
    else
    @gigs = Gig.search(filter_query, includes: [:query_pack, :likes, :user, city: [state: :country]], where: user_where_filter, page: params[:gigs], per_page: 20, execute: false, operator: "or")
    @requests = Request.search(filter_query, includes: [:offers, city: [state: :country]], where: user_where_filter, page: params[:requests], per_page: 20, execute: false, operator: "or")
    Searchkick.multi_search([@gigs, @requests])
    end
    render template: "queries/search_results"
  end

  def user_autocomplete_search
    render json: Searchkick.search(filter_query, {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession],
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
end

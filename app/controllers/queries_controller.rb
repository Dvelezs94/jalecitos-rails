class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  layout :set_layout
  access user: [:user_search, :user_autocomplete_search, :autocomplete_profession, :user_mobile_search], admin: :all, all: [:guest_search, :guest_autocomplete_search]

  def guest_search
    if params[:gigs]
      @gigs = Gig.search(params[:query], where: guest_where_filter, page: params[:gigs], per_page: 20)
    elsif params[:requests]
      @requests = Request.search(params[:query], where: guest_where_filter, page: params[:requests], per_page: 20)
    else
      @gigs = Gig.search(params[:query], where: guest_where_filter, execute: false, page: params[:gigs], per_page: 20)
      @requests = Request.search(params[:query], where: guest_where_filter, execute: false, page: params[:requests], per_page: 20)
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
      @gigs = Gig.search(params[:query], where: user_where_filter, page: params[:gigs], per_page: 20)
    elsif params[:requests]
      @requests = Request.search(params[:query], where: user_where_filter, page: params[:requests], per_page: 20)
    else
    @gigs = Gig.search(params[:query], where: user_where_filter, page: params[:gigs], per_page: 20, execute: false)
    @requests = Request.search(params[:query], where: user_where_filter, page: params[:requests], per_page: 20, execute: false)
    Searchkick.multi_search([@gigs, @requests])
    end
    render template: "queries/search_results"
  end

  def user_autocomplete_search
    render json: Searchkick.search(params[:query], {
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
      load: false,
      misspellings: {below: 2}
    }).map(&:name)
  end

  def user_mobile_search
  end
end

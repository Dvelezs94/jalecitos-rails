class QueriesController < ApplicationController
  include SetLayout
  include SearchFunctions
  include LocationFunctions
  layout :set_layout
  access user: [:user_search, :user_autocomplete_search, :autocomplete_profession], admin: :all, all: [:guest_search, :guest_autocomplete_search]

  def guest_search
    location = get_location(params[:lat], params[:lon]) if params[:lat].present? && params[:lon].present?
    if location.present?
      @gigs = Gig.search(params[:query], where: {status: "published", location: location}, limit: 5, execute: false)
      @requests = Request.search(params[:query], where: {status: "published",location: location}, limit: 5, execute: false)
    else
      @gigs = Gig.search(params[:query], where: {status: "published"}, limit: 5, execute: false)
      @requests = Request.search(params[:query], where: {status: "published"}, limit: 5, execute: false)
    end
    Searchkick.multi_search([@gigs, @requests])
  end

  def guest_autocomplete_search
    render json: Searchkick.search(params[:query], {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession],
      where:  { status: "published" }
    }).suggestions
  end

  def user_search
    @gigs = Gig.search(params[:query], where: where_filter, page: params[:gigs], per_page: 15, execute: false)
    @requests = Request.search(params[:query], where: where_filter, page: params[:gigs], per_page: 15, execute: false)
    Searchkick.multi_search([@gigs, @requests])
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
end

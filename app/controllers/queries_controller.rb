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
      @requests = Request.search(params[:query], where: {status: "open",location: location}, limit: 5, execute: false)
    else
      @gigs = Gig.search(params[:query], where: {status: "published"}, limit: 5, execute: false)
      @requests = Request.search(params[:query], where: {status: "open"}, limit: 5, execute: false)
    end
    Searchkick.multi_search([@gigs, @requests])
  end

  def guest_autocomplete_search
    render json: Searchkick.search(params[:query], {
      index_name: [Gig, Request],
      suggest: [:name, :description, :profession],
      where:  { _or: [{status: "open"}, {status: "published"}] }
    }).suggestions
  end

  def user_search
    location = get_location(params[:lat], params[:lon]) if params[:lat].present? && params[:lon].present?
    if location.present?
      @gigs = Gig.search(params[:query], where: {status: "published", location: location}, limit: 5, execute: false)
      @requests = Request.search(params[:query], where: {status: "open",location: location}, limit: 5, execute: false)
    else
      @gigs = Gig.search(params[:query], where: {status: "published"}, limit: 5, execute: false)
      @requests = Request.search(params[:query], where: {status: "open"}, limit: 5, execute: false)
    end
    Searchkick.multi_search([@gigs, @requests])
  end

  def user_autocomplete_search
    render json: options[:model].search(query, {
      fields: ["name", "description"],
      match: :word_start,
      limit: 10,
      load: false,
      misspellings: {below: 5},
      where: where_filter(options[:status])
    }).map{|x| pre_text(options[:model]) + x.name}
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

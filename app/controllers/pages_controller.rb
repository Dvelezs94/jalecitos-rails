class PagesController < ApplicationController
  include SetLayout
  include SearchFunctions
  before_action :admin_redirect, only: :home
  before_action :pending_review, only: [:home, :finance], :if => :signed_and_rev
  layout :set_layout
  access user: :all, admin: :all, all: [:home, :autocomplete_search]
  def home
    if params[:query]
      options = init_search_options
      @search = search(options[:model], options[:includes], options[:status])
    elsif current_user
      @verified_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 1}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], limit: 5)
      @recommended_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 2}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], limit: 5)
      @featured_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 3}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], limit: 5)
    end
  end

  def request_index
    @requests = Request.includes(:user).open.order(created_at: :desc).page(params[:page])
  end

  def finance
    @purchases = Order.search("*", where: {employer_id: current_user.id}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}])
    @sales = Order.search("*", where: {employee_id: current_user.id, status: {not: "denied"}}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}])
  end

  def liked
    @liked_gigs = Gig.find(current_user.likes.pluck(:gig_id))
  end

  def autocomplete_search
    query = filter_query
    #init the filter params
    options = init_search_options
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

  private

  def pre_text model
    ( model == Gig)? "Voy a " : "Busco a alguien "
  end

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(dashboard_admins_path) : nil
  end



  def pending_review
    #if the review is specific... (when employer finishes work)
    if params[:identifier] && is_number?(params[:identifier])
      #find it and keep it in an array
      @reviews = [ Review.find( params[:identifier] ) ]
      #verify its own and pending
      @reviews = (@reviews.present? )? @reviews.select{ |r| r.pending? && r.giver_id == current_user.id  } : nil
    #if employee clicked a notification of finished work
    elsif params[:notification]  && is_number?(params[:notification])
      #get the notification
      notification = Notification.find(params[:notification])
      #get the gig or request
      object = (notification.notifiable.class == Package )? notification.notifiable.gig : notification.notifiable.request
      #get the reviews of the user with object attributes (if a work has done 2 times, they can be more than 1 review)
      @reviews = Review.search('*', where: { giver_id: current_user.id, reviewable_id: object.id, reviewable_type: object.class.to_s, status: "pending" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #obtain the one that we are looking and check if its still pending
      @reviews = (@reviews.present? )? @reviews.select{ |r| r.pending? } : nil
    #or if its not specific
    else
      #get the recent pending reviews (searchkick just index pending reviews)
      @reviews = Review.search("*", where: { giver_id: current_user.id, status: "pending" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #verify the reviews that are pending (searchkick takes some time to update its records)
      @reviews = (@reviews.present? )? @reviews.select{ |r| r.pending? } : nil
    end
  end


  def signed_and_rev
    (:signed_in? && params[:review] == "true")? true : false
  end



end

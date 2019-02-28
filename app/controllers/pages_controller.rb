class PagesController < ApplicationController
  include SetLayout
  require "i18n"
  before_action :admin_redirect, only: :home
  before_action :pending_review, only: [:home, :finance], :if => :signed_and_rev
  layout :set_layout
  access user: :all, admin: [:home], all: [:home, :autocomplete_search, :terms_and_conditions, :privacy_policy, :sales_conditions, :employer_employee_rules]
  def home
    if params[:current]
      if params[:popular_gigs]
        @popular_gigs = Gig.search("*", includes: [:gigs_packages, :user, :likes, city: [state: :country]], where: conditions, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:popular_gigs], per_page: 15)
      elsif params[:recent_requests]
        @recent_requests = Request.search("*", includes: [city: [state: :country]], where: conditions, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:recent_requests], per_page: 15)
      elsif params[:verified_gigs]
        @verified_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: conditions("verified"), order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:verified_gigs], per_page: 15)
      elsif params[:liked_gigs]
        @liked_gigs = Like.search( "*", where: {user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:liked_gigs], per_page: 15)
        @liked_gigs_items = Gig.includes(:gigs_packages, :user, :likes, city: [state: :country]).where(id: @liked_gigs.results.pluck(:gig_id)).order(created_at: :desc)
      end
      render template: "shared/carousels/add_items_carousel.js.erb"
    elsif current_user
        @popular_gigs = Gig.search("*", includes: [:gigs_packages, :user, :likes, city: [state: :country]], where: conditions, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:popular_gigs], per_page: 15, execute: false)
        @recent_requests = Request.search("*", includes: [city: [state: :country]], where: conditions, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:recent_requests], per_page: 15, execute: false)
        @verified_gigs = Gig.search("*", includes: [:gigs_packages, :user, :likes, city: [state: :country]], where: conditions("verified"), order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:verified_gigs], per_page: 15, execute: false)
        @liked_gigs = Like.search( "*", where: {user_id: current_user.id}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:liked_gigs], per_page: 15, execute: false )
        Searchkick.multi_search([@popular_gigs, @recent_requests, @verified_gigs, @liked_gigs])
        @liked_gigs_items = Gig.includes(:gigs_packages, :user, :likes, city: [state: :country]).where(id: @liked_gigs.results.pluck(:gig_id)).order(created_at: :desc)
    end
  end

  def request_index
    @requests = Request.includes(:user).published.order(created_at: :desc).page(params[:page])
  end

  def finance
    @purchases = Order.search("*", where: {employer_id: current_user.id}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}])
    @sales = Order.search("*", where: {employee_id: current_user.id, status: {not: "denied"}}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}])
  end

  def liked
    @liked_gigs = Gig.find(current_user.likes.pluck(:gig_id))
  end

  def terms_and_conditions
  end

  def privacy_policy
  end

  def sales_conditions
  end

  def employer_employee_rules

  end

  private

  def admin_redirect
    redirect_to(dashboard_admins_path) if (current_user && current_user.has_role?(:admin))
  end



  def pending_review
    #if the review is specific... (when employer finishes work)
    if params[:identifier] && is_number?(params[:identifier])
      #find it and keep it in an array
      @reviews = [ Review.find( params[:identifier] ) ]
      #verify its own and pending
      @reviews = @reviews.select{ |r| r.pending? && r.giver_id == current_user.id  } if @reviews.present?
    #if employee clicked a notification of finished work
    elsif params[:notification]  && is_number?(params[:notification])
      #get the notification
      notification = Notification.find(params[:notification])
      #get the gig or request
      object = (notification.notifiable.class == Package )? notification.notifiable.gig : notification.notifiable.request
      #get the reviews of the user with object attributes (if a work has done 2 times, they can be more than 1 review)
      @reviews = Review.search('*', where: { giver_id: current_user.id, reviewable_id: object.id, reviewable_type: object.class.to_s, status: "pending" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #obtain the one that we are looking and check if its still pending
      @reviews = @reviews.select{ |r| r.pending? } if @reviews.present?
    #or if its not specific
    else
      #get the recent pending reviews (searchkick just index pending reviews)
      @reviews = Review.search("*", where: { giver_id: current_user.id, status: "pending" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #verify the reviews that are pending (searchkick takes some time to update its records)
      @reviews = @reviews.select{ |r| r.pending? } if @reviews.present?
    end
  end

  def conditions string=nil
    if current_user.location(true) && string == "verified"
      {status: "published", city_id: current_user.city_id, verified: true}
    elsif current_user.location(true)
      {status: "published", city_id: current_user.city_id}
    elsif string == "verified"
      {status: "published", verified: true}
    else
      {status: "published"}
    end
  end


  def signed_and_rev
    #format html helps to not query pending reviews when pagination triggers
    (:signed_in? && params[:review] == "true" && request.format.html?)? true : false
  end



end

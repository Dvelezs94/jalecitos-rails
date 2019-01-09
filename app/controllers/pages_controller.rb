class PagesController < ApplicationController
  include SetLayout
  before_action :admin_redirect, only: :home
  before_action :pending_review, only: [:home, :finance], :if => :signed_and_rev
  layout :set_layout
  access user: :all, admin: :all, all: [:home]
  def home
    if params[:query]
      if (params[:model_name] == "requests")
        includes = [:user]
        status = "open"
        model = Request
      else
        includes = [:search_gigs_packages, :user]
        status = "published"
        model = Gig
      end
      @search = search(model, includes, status)
    elsif current_user
        @verified_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 1}, order: {created_at: :desc}, limit: 5)
        @recommended_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 2}, order: {created_at: :desc}, limit: 5)
        @featured_gigs = Gig.search("*", includes: [:gigs_packages, :user], where: {status: "published", category_id: 3}, order: {created_at: :desc}, limit: 5)
    end
  end

  def request_index
    @requests = Request.includes(:user).open.order(created_at: :desc).page(params[:page])
  end

  def finance
    @purchases = current_user.purchases.order(updated_at: :desc)
    @sales = current_user.sales.where.not(status: "denied").order(updated_at: :desc)
  end

  def liked
    @liked_gigs = Gig.find(current_user.likes.pluck(:gig_id))
  end

  private

  def admin_redirect
    (current_user && current_user.has_role?(:admin)) ? redirect_to(dashboard_admins_path) : nil
  end

  def search model, includes, status
    query = (params[:query] == "")?  "*" : params[:query]
    if params[:category_id] != "" && params[:location] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id], location: params[:location]}, page: params[:page], per_page: 20
    elsif params[:category_id] != ""
      model.search query,includes: includes, where: {status: status, category_id: params[:category_id]}, page: params[:page], per_page: 20
    elsif  params[:location] != ""
      model.search query,includes: includes, where: {status: status, location: params[:location]}, page: params[:page], per_page: 20
    else
      model.search query,includes: includes, where: {status: status}, page: params[:page], per_page: 20
    end
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
      #get the reviews of the user
      @reviews = Review.search('*', where: { giver_id: current_user.id, status: "pending" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #get the notification
      notification = Notification.find(params[:notification])
      #get the gig or request
      object = (notification.notifiable.class == Package )? notification.notifiable.gig : notification.notifiable.request
      #obtain the one that we are looking and check if its still pending
      @reviews = (@reviews.present? )? @reviews.select{ |r| r.pending? && r.reviewable_id == object.id && r.reviewable_type == object.class.to_s } : nil
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

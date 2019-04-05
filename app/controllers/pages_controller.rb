class PagesController < ApplicationController
  include SetLayout
  include GetPages
  before_action :admin_redirect, only: :home
  before_action :pending_review, only: [:home, :finance], :if => :signed_and_rev
  layout :set_layout
  access user: :all, admin: [:home], all: [:work, :home, :autocomplete_search, :terms_and_conditions, :privacy_policy, :sales_conditions, :employer_employee_rules, :robots, :sitemap]
  def home
    if params[:current] #if some pagination is present...
      home_paginate
      render template: "shared/carousels/add_items_carousel.js.erb"
    else
      home_get_all
    end
    update_push_subscription if user_signed_in?
  end

  def finance
    if params[:purchases]
      get_purchases(true)
    elsif params[:sales]
      get_sales(true)
    else
      get_purchases
      get_sales
      Searchkick.multi_search([@purchases, @sales])
    end
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

  def robots
    respond_to :text
    expires_in 6.hours, public: true
  end

  def wizard
    if params[:current] #if some pagination is present...
      wizard_paginate
      render template: "shared/carousels/add_items_carousel.js.erb"
    else
      wizard_get_all
      render "home"
    end
  end

  def sitemap
    redirect_to "https://production.jalecitos.com.s3.amazonaws.com/sitemaps/sitemap.xml"
  end

  def work
  end

  private

  def admin_redirect
    redirect_to(dashboard_admins_path) if (current_user && current_user.has_role?(:admin))
  end



  def pending_review
    puts "X"*500
    #if the review is specific... (when employer finishes work)
    if params[:identifier] && is_number?(params[:identifier])
      #find it and keep it in an array
      @p_reviews = [ Review.find( params[:identifier] ) ]
      #verify its own and pending
      @p_reviews = @p_reviews.select{ |r| r.pending? && r.giver_id == current_user.id  } if @p_reviews.present?
    #if employee clicked a notification of finished work
    elsif params[:notification]  && is_number?(params[:notification])
      #get the notification
      notification = Notification.find(params[:notification])
      #get the gig or request
      object = (notification.notifiable.class == Package )? notification.notifiable.gig : notification.notifiable.request
      #get the reviews of the user with object attributes (if a work has done 2 times, they can be more than 1 review)
      @p_reviews = Review.search('*', where: { giver_id: current_user.id, reviewable_id: object.id, reviewable_type: object.class.to_s, status: "pending" }, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], limit: 1)
      #obtain the one that we are looking and check if its still pending
      @p_reviews = @p_reviews.select{ |r| r.pending? } if @p_reviews.present?
    #or if its not specific
    else
      #get the recent pending reviews (searchkick just index pending reviews)
      @p_reviews = Review.search("*", where: { giver_id: current_user.id, status: "pending" }, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], limit: 1)
      #verify the reviews that are pending (searchkick takes some time to update its records)
      @p_reviews = @p_reviews.select{ |r| r.pending? } if @p_reviews.present?
    end
  end


  def signed_and_rev
    #format html helps to not query pending reviews when pagination triggers
    #params[:review] == "true" && request.format.html? OLD
    #request.env["HTTP_TURBOLINKS_REFERRER"].present? tells me if turbolinks visit (no turbolink visit only log in and reload of home)
    (user_signed_in? && request.env["HTTP_TURBOLINKS_REFERRER"].nil? && request.format.html?)? true : false
  end

  def update_push_subscription
    if cookies[:FcmToken]
      PushSubscription.create(user: current_user, auth_key: cookies[:FcmToken])
    end
  end

end

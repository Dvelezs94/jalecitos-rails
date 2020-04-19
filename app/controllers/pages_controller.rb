class PagesController < ApplicationController
  include SetLayout
  include GetPages
  include SearchFunctions
  access user: :all, admin: [:home], all: [:work, :home, :autocomplete_search, :terms_and_conditions, :privacy_policy, :sales_conditions, :employer_employee_rules, :robots, :sitemap, :install, :gig_slugs]
  before_action :admin_redirect, only: :home
  before_action :phone_available, only: :home
  before_action :pending_review, only: [:home], :if => :search_pending_review?
  before_action :go_to_sign_in, only: :home
  layout :set_layout
  def home
    if params[:current] #if some pagination is present...
      home_paginate
      render template: "shared/carousels/add_items_carousel.js.erb"
    else
      get_last_gigs_near_by if user_signed_in?
      #home_get_all
      (user_signed_in?)? render(template: 'shared_user/root/homepage') : render(template: 'shared_guest/root/homepage')
    end
    update_push_subscription if user_signed_in?
  end

  def finance
    if params[:purchases]
      get_purchases
    elsif params[:sales]
      get_sales
    else
      get_purchases
      get_sales
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
      render 'shared_user/root/homepage'
    end
  end

  def sitemap
    redirect_to "https://production.jalecitos.com.s3.amazonaws.com/sitemaps/sitemap.xml"
  end

  def gig_slugs
    #code
  end

  def work
  end

  def install
  end

  private

  def admin_redirect
    redirect_to(dashboard_admins_path) if (current_user && current_user.has_role?(:admin))
  end

  def pending_review
    #if the review is specific... (when employer finishes work)
    if params[:identifier] && is_number?(params[:identifier])
      #find it and keep it in an array
      @p_review = Review.find_by( id: params[:identifier], giver_id: current_user.id, status: "pending" )
    #if employee clicked a notification of finished work
    elsif params[:notification]  && is_number?(params[:notification])
      #get the notification
      notification = Notification.find(params[:notification])
      #get the gig or request
      object = (notification.notifiable.class == Package )? notification.notifiable.gig : notification.notifiable.request
      #get the reviews of the user with object attributes (if a work has done x times, they can be more than 1 review) (starting from oldest)
      @p_review = Review.find_by( giver_id: current_user.id, reviewable: object, status: "pending" )
    #or if its not specific
    else
      #get the pending reviews (starting from oldest)
      @p_review = Review.find_by( giver_id: current_user.id, status: "pending" )
    end
  end

  def phone_available
    if current_user && current_user.phone_number.blank? && !cookies[:phone_available]
      cookies[:phone_available] = {
        expires: (ENV.fetch("RAILS_ENV") == "production")? 1.day: 10.second  #time that elapses to show message again
      }
      @phone_available = true
    end
  end
  def go_to_sign_in
    redirect_to new_user_session_path if ! user_signed_in?
  end

  def search_pending_review?
    #format html helps to not query pending reviews when pagination triggers
    #params[:review] == "true" && request.format.html? OLD
    #request.env["HTTP_TURBOLINKS_REFERRER"].present? tells me if turbolinks visit (no turbolink visit only log in and reload of home)
    #also if params[:notification] is present (used in app notifications or finished orders)
    (user_signed_in? && request.format.html? && (request.env["HTTP_TURBOLINKS_REFERRER"].nil? || params[:notification].present?))? true : false
  end

  def update_push_subscription
    if cookies[:FcmToken]
      if ! PushSubscription.find_by_auth_key(cookies[:FcmToken])
        PushSubscription.create(user: current_user, auth_key: cookies[:FcmToken], device: "mobile")
      end
    end
  end

end

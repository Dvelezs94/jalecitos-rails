module GetPages
  private

  def home_get_all
    if current_user
      get_popular_gigs
      get_recent_requests
      get_recent_gigs
      get_verified_gigs
      get_liked_gigs
      Searchkick.multi_search([@popular_gigs, @recent_requests, @verified_gigs, @liked_gigs, @recent_gigs])
      get_liked_gigs_items
    else
      get_recent_gigs
      get_recent_requests
      Searchkick.multi_search([@recent_gigs, @recent_requests])
    end
  end

  def wizard_paginate
    if params[:wizard_gigs]
      get_wizard_gigs
    elsif params[:wizard_requests]
      get_wizard_requests
    end
  end

  def wizard_get_all
    get_wizard_gigs
    get_wizard_requests
  end

  def get_wizard_gigs
    @wizard_gigs =  Gig.includes(:gigs_packages, :user, :likes, city: [state: :country]).where(status: "wizard").
    page(params[:wizard_gigs]).per(15)
  end

  def get_wizard_requests
    @wizard_requests = Request.includes(city: [state: :country]).where(status: "wizard").
    page(params[:wizard_requests]).per(15)
  end

  def get_popular_gigs bool=false
    @popular_gigs = Gig.search("*",
       includes: [:gigs_packages, :user, :likes, city: [state: :country]],
        where: conditions,
         order: [{ order_count: { order: :desc, unmapped_type: :long}}],
          page: params[:popular_gigs], per_page: 15, execute: bool)
  end

  def get_recent_gigs bool=false
    @recent_gigs = Gig.search("*",
       includes: [:gigs_packages, :user, :likes, city: [state: :country]],
        where: conditions,
         order: [{ created_at: { order: :desc, unmapped_type: :long}}],
          page: params[:recent_gigs], per_page: 15, execute: bool)
  end

  def get_recent_requests bool=false
    @recent_requests = Request.search("*",
       includes: [city: [state: :country]],
        where: conditions, order: [{ created_at: { order: :desc, unmapped_type: :long}}],
         page: params[:recent_requests], per_page: 15, execute: bool)
  end

  def get_verified_gigs bool=false
    @verified_gigs = Gig.search("*",
       includes: [:gigs_packages, :user],
        where: conditions("verified"),
         order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
          page: params[:verified_gigs], per_page: 15, execute: bool)
  end

  def get_liked_gigs bool=false
    @liked_gigs = Like.search( "*",
       where: {user_id: current_user.id},
        order: [{ created_at: { order: :desc, unmapped_type: :long}}],
         page: params[:liked_gigs], per_page: 15, execute: bool)
  end

  def get_liked_gigs_items
    @liked_gigs_items = Gig.includes(:gigs_packages, :user, :likes, city: [state: :country])
    .where(id: @liked_gigs.results.pluck(:gig_id))
    .order(created_at: :desc)
  end

  def get_purchases bool=false
    @purchases = Order.search("*",
       where: {employer_id: current_user.id},
        order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
         per_page: 20, page: params[:purchases], execute: bool)
  end

  def get_sales bool=false
    @sales = Order.search("*",
       where: {employee_id: current_user.id, status: {not: "denied"}},
        order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
         per_page: 20, page: params[:sales], execute: bool)
  end

  def home_paginate
    if params[:popular_gigs]
      get_popular_gigs(true)
    elsif params[:recent_requests]
      get_recent_requests(true)
    elsif params[:verified_gigs]
      get_verified_gigs(true)
    elsif params[:recent_gigs]
      get_recent_gigs(true)
    elsif params[:liked_gigs]
      get_liked_gigs(true)
      get_liked_gigs_items
    end
  end

  def conditions string=nil
    if current_user
      if current_user.location(true) && string == "verified"
        # {status: "published", city_id: current_user.city_id, verified: true}
        {status: "published", verified: true}
      elsif current_user.location(true)
        # {status: "published", city_id: current_user.city_id}
        {status: "published"}
      elsif string == "verified"
        {status: "published", verified: true}
      else
        {status: "published"}
      end
    else # is guest
      {status: "published"}
    end
  end
end

module GetPages
  private

  def home_get_all
    if current_user
      get_popular_gigs
      get_recent_requests
      get_recent_gigs
      get_verified_gigs
      Searchkick.multi_search([@popular_gigs, @recent_requests, @verified_gigs, @recent_gigs])
      get_liked_gigs
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
        where: conditions, boost_where: boost_where_condition,
         boost_by: {order_count: {factor: 100}},
          page: params[:popular_gigs], per_page: 15, execute: bool)
  end

  def get_recent_gigs bool=false
    @recent_gigs = Gig.search("*",
       includes: [:gigs_packages, :user, :likes, city: [state: :country]],
        where: conditions,
         order: [{ created_at: { order: :desc, unmapped_type: :long}}],
          page: params[:recent_gigs], per_page: 15, execute: bool)
  end

  def get_random_gigs
    @random_gigs   = Gig.search("*",
      includes: [:gigs_packages, :user, :likes, city: [state: :country]],
                          body: random_conditions,
                          page: params[:random_gigs],
                          per_page: 15,
                          execute: bool)
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
         boost_where: boost_where_condition, boost_by: {order_count: {factor: 100}},
          page: params[:verified_gigs], per_page: 15, execute: bool)
  end

  def get_liked_gigs
    @liked_gigs = Like.where(user_id: current_user.id).order(created_at: :desc).page(params[:liked_gigs]).per(15)
  end

  def get_liked_gigs_items
    @liked_gigs_items = Gig.includes(:gigs_packages, :user, :likes, city: [state: :country])
    .where(id: @liked_gigs.pluck(:gig_id), status: "published")
    .order(created_at: :desc)
  end

  def get_purchases
    @purchases = Order.includes(:purchase, :employee).where(employer_id: current_user.id).order(updated_at: :desc).page(params[:purchases]).per(20)
  end

  def get_sales
    @sales = Order.includes(:purchase, :employer).where(employee_id: current_user.id).where.not(status: "denied").
    order(updated_at: :desc).page(params[:sales]).per(20)
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
      get_liked_gigs
      get_liked_gigs_items
    end
  end

  def conditions string=nil
    if current_user
      if current_user.location(true) && string == "verified"
        {status: "published", _or: [{state_id: current_user.city.state_id}, {state_id: nil}], verified: true}
        # {status: "published", verified: true}
      elsif current_user.location(true)
        {status: "published", _or: [{state_id: current_user.city.state_id}, {state_id: nil}]}
        # {status: "published"}
      elsif string == "verified"
        {status: "published", verified: true}
      else
        {status: "published"}
      end
    else # is guest
      {status: "published"}
    end
  end

  def boost_where_condition
    {city_id: {value: current_user.city_id, factor: 5}}
  end

  def random_conditions
    #need to test with guests, on guest have to remove filter of city
    seed = Time.zone.now.to_i
    {
      query: {
        function_score: {
          query: {
            bool: {
              must: [
                {
                  term: { status: "published" }
                },
                {
                  bool: {
                    should: [
                      { term: { city_id: current_user.city_id } },
                      bool: {
                        must_not: {
                          exists: { field: "city_id" }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          },
          random_score: {
            seed: seed
          }
        }
      }
    }
  end
end

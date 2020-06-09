module GetPages
  private

  def home_get_all
    if current_user
      get_popular_gigs
      get_recent_requests
      get_recent_gigs
      # get_verified_gigs #when adding this, add also on multi search query
      Searchkick.multi_search([@popular_gigs, @recent_requests, @recent_gigs])
      get_liked_gigs
      get_liked_gigs_items
    else
      # get_recent_gigs #home carousel isnt been triggered
      # get_recent_requests
      # Searchkick.multi_search([@recent_gigs, @recent_requests])
    end
  end

  def get_wizard_gigs
    @wizard_gigs =  Gig.where(status: "wizard").limit(4)
  end

  def get_wizard_requests
    @wizard_requests = Request.where(status: "wizard").limit(4)
  end

  def get_last_gigs_near_by
    @show_x_last_gigs_near_by = 16
    @last_gigs_near_by = Gig.search("*",
       includes: [:user, :likes],
        where: where_filter,
          boost_by: boost_by_score,
            boost_by_distance: boost_by_distance_condition,
              limit: @show_x_last_gigs_near_by, order: { created_at: :desc})
  end

  def get_last_reqs_near_by
    @show_x_last_reqs_near_by = 8
    @last_reqs_near_by = Request.search("*",
        where: where_filter,
            boost_by_distance: boost_by_distance_condition,
              limit: @show_x_last_reqs_near_by, order: { created_at: :desc})
  end

  def get_popular_gigs bool=false
    @popular_gigs = Gig.search("*",
       includes: [:user, :likes, :category, city: [state: :country]],
        where: conditions,
        boost_by_distance: boost_by_distance_condition,
         boost_by: {score: {factor: 100}},
          page: params[:popular_gigs], per_page: 15, execute: bool)
  end

  def get_recent_gigs bool=false
    @recent_gigs = Gig.search("*",
       includes: [:user, :likes, :category, city: [state: :country]],
        where: conditions,
         order: [{ created_at: { order: :desc, unmapped_type: :long}}],
          page: params[:recent_gigs], per_page: 15, execute: bool)
  end

  def get_random_gigs
    @random_gigs   = Gig.search("*",
      includes: [:user, :likes, :category, city: [state: :country]],
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

  def get_liked_gigs
    @liked_gigs = Like.where(user_id: current_user.id).order(created_at: :desc).page(params[:liked_gigs]).per(15)
  end

  def get_liked_gigs_items
    @liked_gigs_items = Gig.includes(:user, :likes, :category, city: [state: :country])
    .where(id: @liked_gigs.pluck(:gig_id), status: "published")
    .order(created_at: :desc)
  end
  def get_verified_gigs bool=false
    @verified_gigs = Gig.search("*",
       includes: [:user, :category],
        where: conditions("verified"),
         boost_where: boost_where_condition, boost_by: {score: {factor: 100}},
          page: params[:verified_gigs], per_page: 15, execute: bool)
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
      if current_user.location(true)
        {status: "published"}
        # {status: "published"}
      else
        {status: "published"}
      end
    else # is guest
      {status: "published"}
    end
  end

  def boost_by_distance_condition
    if current_user.lat
      {location: {origin: {lat: current_user.lat, lon: current_user.lng}, function: "exp"}}
    else #user doesnt has a place of search
      {}
    end
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

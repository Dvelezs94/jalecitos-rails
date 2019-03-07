module GetQuery
  private
  def get_guest_gig bool=false
    @gigs = Gig.search(filter_query,
       includes: [:query_pack, :likes, :user, city: [state: :country]],
        where: guest_where_filter,
         page: params[:gigs], per_page: 20,
          execute: bool, operator: "or")
  end

  def get_guest_request bool=false
    @requests = Request.search(filter_query,
       includes: [:offers, city: [state: :country]],
        where: guest_where_filter, page: params[:requests], per_page: 20,
        execute: bool, operator: "or")
  end

  def get_user_gig bool=false
    @gigs = Gig.search(filter_query,
       includes: [:query_pack, :likes, :user, city: [state: :country]],
        where: user_where_filter, page: params[:gigs],
         per_page: 20, execute: bool, operator: "or")
  end

  def get_user_request bool=false
    @requests = Request.search(filter_query,
       includes: [:offers, city: [state: :country]],
        where: user_where_filter,
         page: params[:requests], per_page: 20,
          execute: bool, operator: "or")
  end

end

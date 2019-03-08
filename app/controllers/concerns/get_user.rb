module GetUser
  private
  def get_reviews bool=false #used in my_account and show
    @reviews = Review.search("*",
       includes: [:giver, :reviewable,:prof_rating],
        where: {receiver_id: @user.id, status: "completed"},
         order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
          page: params[:reviews], per_page: 20, execute: bool)
  end
  def get_gigs bool=false #used in my_account and show
    @gigs = Gig.search("*",
       includes: [:prof_pack, :user, city: [state: :country]],
        where: conditions,
         order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
          execute: bool )
  end

  def get_requests bool=false
    @requests = Request.search("*",
       includes: [city: [state: :country]],
        where: {user_id: @user.id},
         order: [{ updated_at: { order: :desc, unmapped_type: :long}}],
          execute: bool, page: params[:requests], per_page: 20 )
  end

  def conditions
    if params[:action] == "show"
      {user_id: @user.id, status: "published"}
    else
      {user_id: @user.id}
    end
  end
end
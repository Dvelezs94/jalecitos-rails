module GetUser
  private
  def get_reviews #used in my_account and show
    @reviews = Review.includes(:giver, :reviewable,:prof_rating).
    where(receiver_id: @user.id, status: "completed").order(updated_at: :desc).
    page(params[:reviews]).per(10)
  end
  def get_gigs
    @gigs = Gig.where(conditions).order(score_average: :desc).page(params[:gigs]).per(4)
  end

  def get_requests
    @requests = Request.where( user_id: @user.id ).order(created_at: :desc).page(params[:requests]).per(4)
  end

  def conditions
    if params[:action] == "show"
      {user_id: @user.id, status: "published"}
    else
      {user_id: @user.id}
    end
  end
end

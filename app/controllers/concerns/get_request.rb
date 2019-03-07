module GetRequest
  private
  def get_other_offers
    @other_offers = @request.offers.includes(user: :score).where.not(user_id: current_user.id).order(created_at: :desc).page(params[:page]).per(10)
  end
end

class RaterController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_owner
  access user: :all

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate params[:score].to_f, current_user, params[:dimension]

      render :json => true
    else
      render :json => false
    end
  end

  def validate_owner
    #if a review is being rated
    if params[:klass] == "Review"
      @review = Review.find(params[:id])
      #verify the owner
      (@review.giver != current_user)? head(:no_content) : nil
    end
  end
end

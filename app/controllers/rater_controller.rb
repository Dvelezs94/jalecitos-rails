class RaterController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_owner
  before_action :validate_klass
  before_action :validate_score
  access user: :all

  def create
    if user_signed_in?
      obj = params[:klass].classify.constantize.find(params[:id])
      obj.rate(params[:score].to_f, current_user, params[:dimension])

      render :json => true
    else
      render :json => false
    end
  end

  def validate_owner
    #if a review is being rated
    @review = Review.find(params[:id])
    #verify the owner
    (@review.giver == current_user)? nil : head(:no_content)
  end

  def validate_klass
    #permitted classes for rating
    permitted = ["Review"]
    #if is not included, end execution
    ( permitted.include?( params[:klass] ) )? nil : head(:no_content)
  end

  def validate_score
    #check score between 1 and 5 stars
    ( params[:score].to_f.between?(1,5) )? nil : head(:no_content)
  end
end

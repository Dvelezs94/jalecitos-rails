class RaterController < ApplicationController
  access user: :all
  skip_before_action :verify_authenticity_token
  before_action :validate_owner
  before_action :validate_klass
  before_action :validate_score

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
    head(:no_content) if @review.giver != current_user
  end

  def validate_klass
    #permitted classes for rating
    permitted = ["Review"]
    #if is not included, end execution
    head(:no_content) if (! permitted.include?( params[:klass] ) )
  end

  def validate_score
    #check score between 1 and 5 stars
    head(:no_content) if (! params[:score].to_f.between?(1,5) )
  end
end

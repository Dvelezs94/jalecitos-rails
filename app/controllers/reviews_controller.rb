class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :check_review_ownership
  before_action :check_rated
  # before_action :review_once
  access user: :all, admin: :all, all: []

  def update
    #get the params
    fields = review_params
    #if comment is empty, save as nil for saving space
    fields[:comment] = nil if fields[:comment] == ""
    @review.update(fields)
    head :no_content
  end

  private
  def set_review
    @review = Review.find(params[:id])
  end

  def check_review_ownership
    head(:no_content) if (current_user != @review.giver)
  end

  def check_rated
    #update only the rated reviews (if this isnt validated, the review can be completed with rating score of any number (i think) or not scored, so be careful)
    head(:no_content) if ( @review.rating.nil? || ! @review.rating.stars.between?(1,5) )
  end

  def review_once
    head(:no_content) if (! @review.pending?)
  end

  def review_params
    gig_params = params.require(:review).permit(:comment).merge(status: "completed")
  end

end

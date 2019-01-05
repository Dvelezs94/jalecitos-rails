class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :check_review_ownership
  # before_action :review_once
  access user: :all, admin: :all, all: []

  def update
    @review.update(review_params)
    head :no_content
  end

  private
  def set_review
    @review = Review.find(params[:id])
  end

  def check_review_ownership
    (current_user == @review.giver) ? nil : head(:no_content)
  end

  def review_once
    (@review.pending?)? nil : head(:no_content)
  end

  def review_params
    gig_params = params.require(:review).permit(:comment).merge(status: "completed")
  end

end

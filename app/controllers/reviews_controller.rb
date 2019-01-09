class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :check_review_ownership
  # before_action :review_once
  access user: :all, admin: :all, all: []

  def update
    #get the params
    fields = review_params
    #if comment is empty, save as nil for saving space
    (fields[:comment] == "")? fields[:comment] = nil : nil
    #remove comment if its not valid
    (allow_comment)? nil : fields[:comment] = nil
    @review.update(fields)
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

  def allow_comment
    #order of a gig and i am the employer...
    (@review.order.purchase_type == "Package" && @review.order.employer == current_user)? true: false
  end

  def review_params
    gig_params = params.require(:review).permit(:comment).merge(status: "completed")
  end

end

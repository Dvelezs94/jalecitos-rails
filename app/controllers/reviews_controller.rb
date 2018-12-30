class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :check_review_ownership

  def submit
    @review.comment = params.require(:review).permit(:comment)
    @review.save
    @review.completed!
  end

  private
  def set_review
    @review = params[:id]
  end

  def check_review_ownership
    (current_user.nil? || current_user != @review.user) ? redirect_to(root_path) : nil
  end
end

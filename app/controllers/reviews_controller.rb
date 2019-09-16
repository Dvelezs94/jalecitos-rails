class ReviewsController < ApplicationController
  access user: :all, admin: :all
  before_action :authenticate_user!
  before_action :set_review, only: [:update, :destroy]
  before_action :check_review_ownership, only: [:update, :destroy]
  before_action :check_rated, only: [:update]

  before_action :not_recommend_myself, only: [:create]
  before_action :just_one_or_five_stars, only: [:create]
  # before_action :review_once

  def update
    #get the params
    fields = review_params
    #if comment is empty, save as nil for saving space
    fields[:comment] = nil if fields[:comment] == ""
    @success = @review.update(fields)
    # head :no_content
  end

  def create #create recommendation
    fields = recommendation_params
    #if comment is empty, save as nil for saving space
    fields[:comment] = nil if fields[:comment] == ""
    current_user.with_lock do
      @review = Review.new(fields)
      @success = @review.save
      if @success
        fields = rating_params
        @rating = Rate.new(fields)
        @success = @rating.save
        @review.delete if !@success #if no rate, call delete instead of destroy, (calling destroy would try to delete its rate)
      end
    end
  end

  def destroy
    @review.destroy
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

  def not_recommend_myself
    @gig_owner_id = Gig.find(params[:review][:reviewable_id]).user.id
    head(:no_content) if (@gig_owner_id == current_user.id)
  end

  def review_params
    review_params = params.require(:review).permit(:comment).merge(status: "completed")
  end

  def recommendation_params
    review_params = params.require(:review).permit(:comment, :reviewable_id)
    review_params[:status] = "pending"
    review_params[:reviewable_type] = "Gig"
    review_params[:receiver_id] = @gig_owner_id
    review_params[:giver_id] = current_user.id
    review_params[:is_recommendation] = true
    review_params
  end

  def rating_params
    review_params = params.require(:review).permit(rating_attributes: [:stars] )
    review_params[:rating_attributes][:dimension] = "Recommendation"
    review_params[:rating_attributes][:rateable_type] = "Review"
    review_params[:rating_attributes][:rateable_id] = @review.id
    review_params[:rating_attributes][:rater_id] = current_user.id
    review_params[:rating_attributes]
  end

  def just_one_or_five_stars
    stars = params[:review][:rating_attributes][:stars]
    head(:no_content) if stars != "5" && stars != "1"
  end


end

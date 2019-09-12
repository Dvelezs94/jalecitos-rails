class RecommendationWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(review_id)
    review = Review.find(review_id)
    @gig_owner = review.reviewable.user.score
    @gig_owner.with_lock do
      @gig_owner.employee_score_average = ((@gig_owner.employee_score_average * @gig_owner.employee_score_times) + review.rating.stars) / (@gig_owner.employee_score_times + 1)
      @gig_owner.employee_score_times += 1
      @gig_owner.save
    end
    @gig = review.reviewable
    if @gig.present? #if package exists (not deleted the gig)
      @gig.with_lock do
        @gig.score_average = ((@gig.score_average * @gig.score_times) + review.rating.stars) / (@gig.score_times + 1)
        @gig.score_times += 1
        @gig.save
      end
    end
  end
end

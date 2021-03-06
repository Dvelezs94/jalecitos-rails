class GigAverageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false

  def perform(review_id)
    review = Review.find(review_id)
    purchase = review.order.purchase
    if purchase.present? #if package exists (not deleted the gig)
      @gig = purchase.gig
      @gig.with_lock do
        @gig.score_average = ((@gig.score_average * @gig.score_times) + review.rating.stars) / (@gig.score_times + 1)
        @gig.score_times += 1
        @gig.save
      end
    end
  end
end

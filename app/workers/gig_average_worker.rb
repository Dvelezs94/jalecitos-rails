class GigAverageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(review_id)
    review = Review.find(review_id)
    @gig = review.order.purchase.gig
    @gig.with_lock do
      @gig.score_average = ((@gig.score_average * @gig.score_times) + review.rating.stars) / (@gig.score_times + 1)
      @gig.score_times += 1
      @gig.save
    end
  end
end

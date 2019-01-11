class EmployerAverageWorker
  include Sidekiq::Worker

  def perform(review)
    review = Review.find(review_id)
    @employer = review.order.employer.score
    @employer.with_lock do
      @employer.employer_score_average = ((@employer.employer_score_average * @employer.employer_score_times) + review.rating.stars) / (@employer.employer_score_times + 1)
      @employer.employer_score_times += 1
      @employer.save
    end
  end
end

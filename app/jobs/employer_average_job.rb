class EmployerAverageJob < ApplicationJob
  queue_as :default

  def perform(review)
    @employer = review.order.employer.user_score
    @employer.with_lock do
      @employer.employer_score_average = ((@employer.employer_score_average * @employer.employer_score_times) + review.rating.stars) / (@employer.employer_score_times + 1)
      @employer.employer_score_times += 1
      @employer.save
    end
  end
end

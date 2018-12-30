class EmployeeAverageJob < ApplicationJob
  queue_as :default

  def perform(review)
    @employee = review.order.employee.score
    @employee.with_lock do
      @employee.employee_score_average = ((@employee.employee_score_average * @employee.employee_score_times) + review.rating.stars) / (@employee.employee_score_times + 1)
      @employee.employee_score_times += 1
      @employee.save
    end
  end
end

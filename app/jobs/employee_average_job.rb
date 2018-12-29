class EmployeeAverageJob < ApplicationJob
  queue_as :default

  def perform(review)
    # Do something later
  end
end

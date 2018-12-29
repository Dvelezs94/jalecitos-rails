class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension

  # Run Gig average job to update score
  after_commit :resource_average, on: :create

  # method to average the gig and the user score
  def resource_average
    # check if the rating is for a review
    if :rateable_type == "Review"
      # Rate the Gig and User for employee
      if self.order.employee
        GigAverageJob.perform_later(self)
        EmployeeAverageJob.perform_later(self)
      # Rate User for employer
      else
        EmployerAverageJob.perform_later(self)
      end
    end
  end
  
end

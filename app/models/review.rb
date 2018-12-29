class Review < ApplicationRecord
  #search
  searchkick language: "spanish"

  def search_data
    {
      user_id: user_id,
      status: status
    }
  end

  belongs_to :order
  belongs_to :user
  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'
  enum status: { pending: 0, completed: 1 }

  def rating
    Rate.where(rateable: self).first
  end

  # Run Gig average job to update score
  after_commit :resource_average, on: :update, if: :saved_changes_to_status?

  # method to average the gig and the user score
  def resource_average
      # Rate the Gig and User for employee
      if self.order.employee
        # Rate the Gig if the purchase class is package
        if self.order.purchase.class == Package
          GigAverageJob.perform_later(self)
        end
        EmployeeAverageJob.perform_later(self)
      # Rate User for employer
      else
        EmployerAverageJob.perform_later(self)
      end
  end
end

class Review < ApplicationRecord
  #search
  searchkick language: "spanish"

  def search_data
    {
      giver_id: giver_id,
      status: status,
      created_at: created_at
    }
  end

  belongs_to :order
  belongs_to :giver, foreign_key: :giver_id, class_name: "User"
  belongs_to :reviewable, polymorphic: true
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
    #if the user rated the review and not pressed the cancel button
    if self.rating.present? && self.rating.stars != 0
      # if the user that rated is the employer rate the employee
      if self.giver == self.order.employer
        # Rate the Gig if the purchase class is package
        if self.reviewable_type == "Gig"
          GigAverageJob.perform_later(self)
        end
        EmployeeAverageJob.perform_later(self)
      # Rate the employer
      else
        EmployerAverageJob.perform_later(self)
      end
    end
  end
end

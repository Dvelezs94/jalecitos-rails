class Review < ApplicationRecord
  #search
  searchkick language: "spanish"

  def search_data
    {
      giver_id: giver_id,
      receiver_id: receiver_id,
      reviewable_type: reviewable_type,
      reviewable_id: reviewable_id,
      status: status,
      updated_at: updated_at
    }
  end

  #Associations
  belongs_to :order
  belongs_to :giver, foreign_key: :giver_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"
  belongs_to :reviewable, :polymorphic => true
  has_one :prof_rating, ->{ limit(20)}, class_name: 'Rate', as: :rateable
  has_one :gig_rating, ->{ limit(5)}, class_name: 'Rate', as: :rateable
  has_one :rating, class_name: 'Rate', as: :rateable #limit 1 by default, this is used in reviews controller

  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'
  enum status: { pending: 0, completed: 1 }

  #validations
  validates_length_of :comment, :maximum => 2000

  # Run Gig average job to update score
  after_commit :resource_average, on: :update

  # method to average the gig and the user score
  def resource_average
    #if the user rated the review and not pressed the cancel button
    if self.rating.present? && self.rating.stars != 0
      # if the user that rated is the employer rate the employee
      if self.giver == self.order.employer
        # Rate the Gig if the purchase class is package
        if self.reviewable_type == "Gig"
          GigAverageWorker.perform_async(self.id)
        end
        EmployeeAverageWorker.perform_async(self.id)
      # Rate the employer
      else
        EmployerAverageWorker.perform_async(self.id)
      end
    end
  end
end

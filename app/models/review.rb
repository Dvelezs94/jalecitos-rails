class Review < ApplicationRecord
  # #search
  #callbacks false make sync off so records are not added automatically
   searchkick language: "spanish",callbacks: false
   attr_accessor :is_recommendation
  #
  # def search_data
  #   {
  #     giver_id: giver_id,
  #     receiver_id: receiver_id,
  #     reviewable_type: reviewable_type,
  #     reviewable_id: reviewable_id,
  #     status: status,
  #     updated_at: updated_at
  #   }
  # end
  #Associations
  belongs_to :order, optional: true #no hire, recommendations
  belongs_to :giver, foreign_key: :giver_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"
  belongs_to :reviewable, :polymorphic => true, optional: true #package can be deleted
  has_one :prof_rating, ->{ limit(20)}, class_name: 'Rate', as: :rateable
  has_one :gig_rating, ->{ limit(5)}, class_name: 'Rate', as: :rateable
  has_one :rating, class_name: 'Rate', as: :rateable, dependent: :destroy #limit 1 by default, this is used in reviews controller

  validates_presence_of :reviewable, on: :create

  validate :just_one_recomendation, if: :is_recommendation?, on: :create

  # Options to rate
  ratyrate_rateable 'Employee', 'Employer', "Recommendation"
  enum status: { pending: 0, completed: 1 }

  #validations
  validates_length_of :comment, :maximum => 2000

  # Run Gig average job to update score
  before_update :resource_average, if: :status_changed_to_completed?
  before_destroy :modify_scores

  # method to average the gig and the user score
  def resource_average
    #if the user rated the review and not pressed the cancel button
    if self.rating.present? && self.rating.stars != 0
      if self.rating.dimension == "Recommendation"
        RecommendationWorker.perform_async(self.id)
      # if the user that rated is the employer
      elsif self.giver == self.order.employer
        # Rate the Gig if the purchase class is package
        if self.reviewable_type == "Gig"
          GigAverageWorker.perform_async(self.id)
        end
        EmployeeAverageWorker.perform_async(self.id)
      # employee is rating...
      else
        EmployerAverageWorker.perform_async(self.id)
      end
    end
  end
  def just_one_recomendation
    review = Review.find_by(giver_id: giver_id, reviewable_id: reviewable_id, order_id: nil) #if order id not present, is a recommendation
    # errors.add(:base, "Ya has dado una calificación a este Jale") if review.present?
  end

  def is_recommendation?
    is_recommendation
  end

  def status_changed_to_completed?
    status_changed?(to: "completed")
  end
  def modify_scores
    # if score times -1 is equal o 0, then there is just one review, so i can simply put 0 on average
    @gig_owner = self.reviewable.user.score
    @gig_owner.with_lock do
      @gig_owner.employee_score_average = (@gig_owner.employee_score_times - 1 == 0)? 0 : ((@gig_owner.employee_score_average * @gig_owner.employee_score_times) - self.rating.stars) / (@gig_owner.employee_score_times - 1)
      @gig_owner.employee_score_times -= 1
      @gig_owner.save
    end
    @gig = self.reviewable
    if @gig.present?
      @gig.with_lock do
        @gig.score_average = (@gig.score_times - 1 == 0)? 0 : ((@gig.score_average * @gig.score_times) - self.rating.stars) / (@gig.score_times - 1)
        @gig.score_times -= 1
        @gig.save
      end
    end
  end
end

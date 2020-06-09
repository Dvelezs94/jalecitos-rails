class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  after_commit :update_review, on: :create, if: :is_recommendation?
  before_update :modify_scores, if: :stars_changed?
  #attr_accessible :rate, :dimension

  def modify_scores
    # if score times -1 is equal o 0, then there is just one review, so i can simply put 0 on average
    @gig_owner = self.rateable.reviewable.user.score
    difference = (stars - stars_was).to_i
    @gig_owner.with_lock do
      @gig_owner.employee_score_average = ((@gig_owner.employee_score_average * @gig_owner.employee_score_times) + difference) / (@gig_owner.employee_score_times)
      @gig_owner.save
    end
    @gig = self.rateable.reviewable
    if @gig.present?
      @gig.with_lock do
          @gig.score_average = ((@gig.score_average * @gig.score_times) + difference) / (@gig.score_times)
          @gig.save
      end
    end
  end

  def update_review
    rateable.update(status: "completed")
  end

  def is_recommendation?
    dimension == "Recommendation"? true : false
  end

end

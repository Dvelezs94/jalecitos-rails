class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  after_commit :update_review, on: :create, if: :is_recommendation?
  #attr_accessible :rate, :dimension

  def update_review
    rateable.update(status: "completed")
  end
  def is_recommendation?
    dimension == "Recommendation"? true : false
  end

end

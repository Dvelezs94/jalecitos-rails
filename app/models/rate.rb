class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension

  # Run Gig average job to update score
  after_commit -> { GigAverageJob.perform_later(self) }, on: :create, :if => :rateable_type == "Review"

end

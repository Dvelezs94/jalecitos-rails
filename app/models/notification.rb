class Notification < ApplicationRecord
  #this is useful when i want to pass the review for the job
  attr_accessor :review_id

  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true
  #search
  searchkick language: "spanish"

  # Trigger notification after it is created
  after_commit -> { NotificationRelayJob.perform_later(self, review_id) }, on: :create
end

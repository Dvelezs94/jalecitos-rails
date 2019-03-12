class Notification < ApplicationRecord
  #this is useful when i want to pass the review for the job
  attr_accessor :review_id

  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true, optional: true #optional because a gig can be erased, so its packages also
  #search
  searchkick language: "spanish"

  def search_data
    {
      recipient_id: recipient_id,
      read_at: read_at,
      created_at: created_at
     }
  end

  # Trigger notification after it is created
  after_commit -> { NotificationRelayWorker.perform_async(self.id, review_id) }, on: :create
end

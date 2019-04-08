class Notification < ApplicationRecord
  #this is useful when i want to pass the review for the job
  attr_accessor :review_id
  # #search
  #callbacks false make sync off so records are not added automatically
   searchkick language: "spanish",callbacks: false
  #
  # def search_data
  #   {
  #     recipient_id: recipient_id,
  #     read_at: read_at,
  #     created_at: created_at
  #    }
  # end

  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :notifiable, polymorphic: true, optional: true #optional because a gig can be erased, so its packages also

  # Trigger notification after it is created
  after_commit -> { NotificationRelayWorker.perform_async(self.id, review_id) }, on: :create
end

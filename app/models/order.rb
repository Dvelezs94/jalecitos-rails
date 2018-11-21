class Order < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"
  belongs_to :purchase, polymorphic: true
  belongs_to :withdrawal, optional: true
  has_one :dispute
  after_create :set_access_uuid

  enum status: { pending: 0, denied: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}

  private

   def set_access_uuid
     self.uuid = generate_uuid
   end

   def generate_uuid
     uuid = SecureRandom.hex(2).to_s + self.id.to_s
   end
end

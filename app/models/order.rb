class Order < ApplicationRecord
  #Actions
  after_create :set_access_uuid
  belongs_to :employer, foreign_key: :user_id, class_name: "User"
  belongs_to :employee, foreign_key: :employee_id, class_name: "User"
  belongs_to :purchase, polymorphic: true
  belongs_to :withdrawal, optional: true
  #Associations
  has_one :dispute
  has_many :employer_review, ->{ where(user: self_employer()).limit(1) }, class_name: 'Review'
  has_many :employee_review, ->{ where(user: self.employee).limit(1) }, class_name: 'Review'

  enum status: { pending: 0, denied: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}

  def self_employer
    self.employer
  end
  private

   def set_access_uuid
     self.uuid = generate_uuid
   end

   def generate_uuid
     uuid = SecureRandom.hex(2).to_s + self.id.to_s
   end
end

class Order < ApplicationRecord
  belongs_to :employer, foreign_key: :user_id, class_name: "User"
  belongs_to :employee, foreign_key: :employee_id, class_name: "User"
  belongs_to :purchase, polymorphic: true
  belongs_to :withdrawal, optional: true
  has_one :dispute
  after_create :set_access_uuid
  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'
  has_one :employee_review, through: :review
  has_one :employer_review, through: :review

  enum status: { pending: 0, denied: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}

  private

   def set_access_uuid
     self.uuid = generate_uuid
   end

   def generate_uuid
     uuid = SecureRandom.hex(2).to_s + self.id.to_s
   end
end

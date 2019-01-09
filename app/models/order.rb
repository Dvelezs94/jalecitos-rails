class Order < ApplicationRecord
  #Actions
  after_create :set_access_uuid
  belongs_to :employer, foreign_key: :user_id, class_name: "User"
  belongs_to :employee, foreign_key: :employee_id, class_name: "User"
  belongs_to :purchase, polymorphic: true
  belongs_to :withdrawal, optional: true
  #Associations
  has_one :dispute
  has_many :reviews
  has_one :employer_review, -> (employer) { where(user: employer) }, class_name: 'Review'
  has_one :employee_review, -> (employee) { where(user: employee) }, class_name: 'Review'
  belongs_to :billing_profile, optional: true

  # Order status
  enum status: { pending: 0, denied: 1, in_progress: 2, disputed: 3, completed: 4, refunded: 5}
  # Invoice status, in case there is any
  enum invoice_status: { invoice_pending: 0, invoice_completed: 1, invoice_error: 2, platform_error: 3}

  private

   def set_access_uuid
     self.uuid = generate_uuid
   end

   def generate_uuid
     uuid = SecureRandom.hex(2).to_s + self.id.to_s
   end
end

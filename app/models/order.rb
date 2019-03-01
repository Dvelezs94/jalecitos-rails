class Order < ApplicationRecord
  include ActiveModel::Dirty
  include OpenpayHelper
  include OrderFunctions
  #search
  searchkick language: "spanish"

  def search_data
    {
      employer_id: employer_id,
      employee_id: employee_id,
      status: status,
      updated_at: updated_at
     }
  end
  #Actions
  after_create :set_access_uuid
  belongs_to :employer, foreign_key: :employer_id, class_name: "User"
  belongs_to :employee, foreign_key: :employee_id, class_name: "User"
  belongs_to :purchase, polymorphic: true, optional: true
  belongs_to :payout, optional: true
  validates_presence_of :purchase, :employer, :employee, :card_id
  #Associations
  has_one :dispute
  has_many :reviews
  has_one :employer_review, -> (employer) { where(user: employer) }, class_name: 'Review'
  has_one :employee_review, -> (employee) { where(user: employee) }, class_name: 'Review'
  belongs_to :billing_profile, optional: true

  # Order status
  enum status: { waiting_for_bank_approval: 0, pending: 1, denied: 2, in_progress: 3, disputed: 4, completed: 5, refund_in_progress: 6, refunded: 7}
  # Invoice status, in case there is any
  enum invoice_status: { invoice_pending: 0, invoice_completed: 1, invoice_error: 2, platform_error: 3}
  # Actions after a request is completed
  before_update -> {[increment_count(self), finish_order_request(self), generate_invoice(self)]}, if: :status_change_to_completed?

  private
    def status_change_to_completed?
      status_changed?(to: "completed")
    end

   def set_access_uuid
     self.uuid = generate_uuid
   end

   def generate_uuid
     uuid = SecureRandom.hex(2).to_s + self.id.to_s
   end
end

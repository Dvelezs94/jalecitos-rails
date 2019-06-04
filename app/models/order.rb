class Order < ApplicationRecord
  include ActiveModel::Dirty
  include OrderFunctions
  include OpenpayHelper
  include OpenpayFunctions
  include ApplicationHelper
  # #search
  #callbacks false make sync off so records are not added automatically
   searchkick language: "spanish",callbacks: false
  #
  # def search_data
  #   {
  #     employer_id: employer_id,
  #     employee_id: employee_id,
  #     status: status,
  #     updated_at: updated_at
  #    }
  # end
  #Actions
  validates_presence_of :purchase, :employer, :employee, :card_id, on: :create
  validate :just_one_hire_in_request, :on => :create
  after_create :set_access_uuid
  validate :try_to_refund, if: :change_to_refund_in_progress?, :on => :update
  validate :cant_change_from_refunded, :on => :update
  #Associations
  belongs_to :employer, foreign_key: :employer_id, class_name: "User"
  belongs_to :employee, foreign_key: :employee_id, class_name: "User"
  belongs_to :purchase, polymorphic: true, optional: true
  belongs_to :payout, optional: true
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

   def just_one_hire_in_request
     #just can try to hire one offer at time
     if self.purchase_type == "Offer"
       request = self.purchase.request
       if request.employee.present?
         errors.add(:base, "Sólo puedes contratar a un talento a la vez")
       else #maybe a payment is in process, so i have to consider it
         my_request_hires = Order.includes(purchase: :request).where(employer: self.employer, purchase_type: "Offer").where.not(status: ["denied", "refund_in_progress", "refunded"])
         my_request_hires.each do |mrh|
          errors.add(:base, "Sólo puedes contratar a un talento a la vez") if mrh.purchase.request == self.purchase.request #if the usas has already hired someone on that request, deny the hire
         end
      end
     end
   end

   def change_to_refund_in_progress?
     status_changed?(to: "refund_in_progress")
   end

   def try_to_refund
     if !(status_changed?(from: "pending") || status_changed?(from: "in_progress"))
       errors.add(:base, "El recurso no puede ser reembolsado por su estado actual")
     else
       begin
         init_openpay("charge")
         request_hash = {
           "description" => "Monto de la orden #{self.uuid} devuelto por la cantidad de #{self.total}",
           "amount" => self.total
         }
         response = @charge.refund(self.response_order_id ,request_hash, self.employer.openpay_id)
         self.response_refund_id = response["id"]
       rescue
        errors.add(:base, "Ocurrió un error al intentar de reembolsar la orden") #openpay connection error
       end
     end
   end

   def cant_change_from_refunded
     if status_changed?(from: "refunded")
       errors.add(:base, "El recurso no puede ser actualizado ya que ha sido reembolsado")
     elsif status_changed?(from: "refund_in_progress", to: "refunded")
       return true
     elsif status_changed?(from: "refund_in_progress")
       errors.add(:base, "El recurso no puede ser actualizado ya que hay un reembolso en progreso")
     end
   end
end

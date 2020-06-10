class Order < ApplicationRecord
  attr_accessor :pending_refund_worker, :c_user, :finish_order_worker, :employer_review_id
  include ActiveModel::Dirty
  include OrderFunctions

  # include OpenpayFunctions
  include MoneyHelper
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
  validate :invalid_changes, :on => :update
  validates_presence_of :purchase, :employer, :employee, :card_id, on: :create
  validate :just_one_hire_in_request, :on => :create
  after_create :set_access_uuid
  before_update :try_to_refund, if: :change_to_refund_in_progress?
  before_update :request_the_refund, if: :pending_refund_worker?
  before_update :start_stuff, if: :started_at_changed?
  before_update :request_complete_stuff, if: :completed_at_changed?
  after_validation :complete_stuff, if: :changed_to_completed
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

  # payment verification enum
  enum payment_verification: { payment_verification_pending: 0, payment_verification_failed: 1, payment_verification_passed: 2}

  # Actions after a request is completed
  before_update -> {[increment_count(self), finish_order_request(self), generate_invoice(self)]}, if: :status_change_to_completed?

  def request_the_refund
    init_openpay("charge")
    request_hash = {
      "description" => "Monto de la orden #{self.uuid} devuelto por la cantidad de #{self.total}",
      "amount" => self.total
    }
    begin
      response = @charge.refund(self.response_order_id ,request_hash, self.employer.openpay_id)
      self.response_refund_id = response["id"]
    rescue
      true # job will do it later
    end
  end

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
     self.dispute.update(status: "refunded") if self.dispute
     create_notification(employee, employer, "Se te reembolsará", self, "purchases") #notification for employer
     request_the_refund
   end

   def request_complete_stuff
     create_notification(self.employee, self.employer, "solicitó finalizar", self.purchase, "purchases")
     OrderMailer.order_request_finish(self).deliver
     # Queue job to finish the order in 72 hours
     if ENV.fetch("RAILS_ENV") == "production"
       FinishOrderWorker.perform_in(72.hours, self.id)
     else
       FinishOrderWorker.perform_in(10.seconds, self.id)
     end
   end

   def start_stuff
     create_notification(self.employee, self.employer, "ha comenzado", self.purchase, "purchases")
     OrderMailer.order_started(self).deliver
   end

   def complete_stuff
     #after_validation runs even though validation fails, so i have to make sure that no errors to run this
     return if self.errors.any? #if validation fails, dont do all this stuff
     init_openpay("transfer")
     init_openpay("fee")
     begin
       #Openpay call to transfer the fee to the Employee
       pay_to_customer(self, @transfer)
       #Charge the fee
       charge_fee(self, @fee)
       #charge tax
       charge_tax(self, @fee)
       # charge openpay tax
       openpay_tax(self, @fee)
     rescue
       OrderMailer.error_worker(self.uuid).deliver if finish_order_worker #notify support that the worker failed
       errors.add(:base, "Error al conectar con el servidor de pagos, por favor, inténtalo más tarde") and return
     end
     #do all this if no errors
     self.dispute.proceeded! if self.dispute
     create_reviews(self)
     if finish_order_worker
       create_notification(self.employer, self.employee, "Se ha finalizado", self.purchase, nil, @employee_review.id)
       create_notification(self.employee, self.employer, "Se ha finalizado", self.purchase, nil, @employer_review.id)
       OrderMailer.completed_after_72_hours(self).deliver
     else
       create_notification(self.employer, self.employee, "ha finalizado", self.purchase, nil, @employee_review.id)
       self.employer_review_id = @employer_review.id #used to pass as argument of url to grade employee
       OrderMailer.order_finished(self).deliver
     end
   end

   def invalid_changes
     # IMPORTANT: i check if c_user is present because sometimes i leave it nil, for exmpale when i ban a report, i dont place the c_user and it triggers an error because i want to get c_user.id and c_user is nil
     #try to refund when not pending, in_progress or disputed
     if status_changed?(to: "refund_in_progress") && !( status_changed?(from: "pending") || status_changed?(from: "in_progress") || status_changed?(from: "disputed") )
       errors.add(:base, "El recurso no puede ser reembolsado por su estado actual")
       #only admin can refund disputed order
     elsif status_changed?(to: "refund_in_progress")  &&  status_changed?(from: "disputed") && c_user.present? && (! c_user.has_roles?(:admin) )
       errors.add(:base, "Sólo soporte puede reembolsar un recurso disputado")
       #employer cant refund orders in progress
     elsif status_changed?(to: "refund_in_progress")  &&  status_changed?(from: "in_progress") && c_user.present? && c_user.id == self.employer_id
       errors.add(:base, "No puedes reembolsar el recurso ya que está en progreso")
     #when trying to refund they cant change to other state than refunded
     elsif status_changed?(from: "refund_in_progress") && ! status_changed?(to: "refunded")
       errors.add(:base, "El recurso no puede ser actualizado ya que hay un reembolso en progreso")
       #if request refunded order can just change to refunded!!!
     elsif self.purchase_type == "Offer" && self.purchase.request.banned? && ( !status_changed?(to: "refunded") )
       errors.add(:base, "El recurso está bloqueado, se reembolsará el dinero")
     elsif self.response_order_id.nil?
      errors.add(:base, "Esta orden no ha sido procesada y por lo tanto no puede comenzar")
      #if its not my order i cant change it
    elsif c_user.present? && c_user != self.employee && c_user != self.employer && (! c_user.has_role?(:admin))
       errors.add(:base, "No tienes permiso para acceder aquí")
      #just employer and employee can do certain things
    elsif status_changed?(to: "complete") && c_user.present? && c_user != self.employer && (! c_user.has_role?(:admin))
       errors.add(:base, "Sólo el empleador puede completar la orden")
     elsif status_changed?(to: "in_progress") && c_user.present? && c_user != self.employee && (! c_user.has_role?(:admin))
       errors.add(:base, "Sólo el empleado puede comenzar la orden")
     elsif completed_at_changed? && c_user.present? && c_user != self.employee && (! c_user.has_role?(:admin))
       errors.add(:base, "Sólo el empleado puede solicitar finalizar la orden")
     elsif status_changed?(to: "completed") && status_changed?(from: "disputed") && ( ! c_user.has_roles?(:admin) )
      errors.add(:base, "Sólo soporte puede completar un recurso disputado")
     elsif status_changed?(from: "refunded")
       errors.add(:base, "El recurso no puede ser actualizado ya que ha sido reembolsado")
     elsif status_changed?(from: "denied")
       errors.add(:base, "El recurso no puede ser actualizado ya que ha sido denegado")
     elsif status_changed?(from: "completed")
       errors.add(:base, "El recurso no puede ser actualizado ya que ha sido completado")
     end
   end

   def pending_refund_worker?
     pending_refund_worker
   end
   def changed_to_completed
     status_changed?(to: "completed")
   end
end

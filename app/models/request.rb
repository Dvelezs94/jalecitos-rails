class Request < ApplicationRecord
  attr_accessor :passed_active_order, :payment_success_and_request_banned_or_closed_or_employer_inactive, :payment_success_and_employee_not_active
  #includes
  include TagRestrictions
  include RequestsHelper
  include LocationFunctions
  include FilterRestrictions
  include GigRequestFunctions
  include BeforeDestroyFunctions
  include ApplicationHelper
  #search
  searchkick language: "spanish", word_start: [:name, :description, :profession, :tags], suggest: [:name, :description, :profession, :tags]
  def search_data
    {
      name: no_special_chars(name).downcase,
      #remove special chars
      description: no_special_chars(description),
      tags: tag_list.join(" "),
      city_id: city_id,
      category_id: category_id,
      status: status,
      user_id: user_id,
      profession: profession,
      created_at: created_at
     }
  end
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Enums
  enum status: { published: 0, in_progress: 1, completed: 2, closed: 3, banned: 4, wizard: 5}
  #Associations
  belongs_to :user
  belongs_to :category
  belongs_to :city, optional: true
  has_many :offers, dependent: :destroy
  belongs_to :employee, class_name: "User", optional: true
  #Validations
  validates_presence_of :name, :description, :budget, :category_id
  validate  :tag_length, :no_spaces_in_tag, :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :profession, :maximum => 50, :message => "debe contener como máximo 50 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  validate :location_validate
  validate :budget_options
  validate :invalid_change, on: :update
  validate :finished_request, on: :update
  before_update :refund_money, if: :interrupting_request?
  #Custom fields
  mount_uploaders :images, RequestUploader
  validates :images, length: {
    maximum: 3,
    message: 'no puedes tener más de 3 imágenes'
  }
  before_destroy :mark_reports_and_bans
  #notify users when new request is made
  after_commit -> { NotifyNewRequestWorker.perform_async(self.id) }, on: :create

  #Actions
  #capitalize before save
  def profession=(val)
    write_attribute(:profession, no_multi_spaces(val.strip.capitalize))
  end

  def finished_request
    if status_changed?(to: "completed") || status_changed?(to: "closed")
      reports = Report.where(status: "open", reportable: self)
      reports.each do |r|
        r.update!(status: "finished_resource") #the resource wasnt treated, the users finished it
      end
    end
  end

  def interrupting_request?
    status_changed?(from: "in_progress", to: "banned") || status_changed?(from: "in_progress", to: "closed") || payment_success_and_request_banned_or_closed_or_employer_inactive || payment_success_and_employee_not_active
  end

  def refund_money
    begin
      active_order = passed_active_order || self.active_order
      if payment_success_and_employee_not_active
        create_notification(active_order.employee, active_order.employer, "El talento", active_order, "purchases")
      else #request banned, closed, or payment success but request banned or closed, or some user refunded or employer inactive
        create_notification(active_order.employee, active_order.employer, "Se te reembolsará", active_order, "purchases")
      end
      active_order.update(status: "refund_in_progress")
    rescue # if openpay is down, the job will do it later
      true
    end
  end

  def refund_money_for_worker # no notification again
    begin
      active_order = self.active_order
      active_order.update(status: "refund_in_progress")
    rescue # if openpay is down, the job will do it later
      true
    end
  end

  def invalid_change
    if status_changed?(from: "completed", to: "banned")
      errors.add(:base, "El recurso ya se ha completado, así que no tiene sentido bloquearlo")
    end
    if status_changed?(from: "wizard", to: "banned")
      errors.add(:base, "No se puede bloquear un recurso de jalecitos")
    end
    if status_changed?(from: "closed", to: "banned")
      errors.add(:base, "El pedido ya se ha cerrado antes")
    end
    # if status_changed?(from: "disputed", to: "banned")
    #   errors.add(:base, "El pedido ya está en disputa")
    # end
  end

  def description=(val)
    write_attribute(:description, no_multi_spaces(val.strip))
  end

  def title
    "Busco #{to_downcase(self.name)}"
  end

  def budget_options
    if ! options_for_budget.include?(self.budget)
      errors.add(:base, "No seleccionaste un presupuesto válido.")
    end
  end

  #a request can have many orders becuse payment can be denied
  #the active order is the one that is hired (payment was successful), it can just exist one
  def active_order
    request_offers = self.offers
    the_active_order = Order.where(employer_id: self.user_id, purchase: request_offers).where.not(status: ["denied", "waiting_for_bank_approval"]).limit(1).first
  end
  def active_order?
    request_offers = self.offers
    the_active_order = Order.where(employer_id: self.user_id, purchase: request_offers).where.not(status: ["denied", "waiting_for_bank_approval"]).limit(1).first
    return the_active_order.present?
  end

  def all_orders
    request_offers = self.offers
    the_active_order = Order.where(employer_id: self.user_id, purchase: request_offers)
  end
end

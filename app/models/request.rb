class Request < ApplicationRecord
  attr_accessor :passed_active_order, :payment_success_and_request_banned_or_closed_or_employer_inactive, :payment_success_and_employee_not_active, :c_user
  #includes
  include TagRestrictions
  include RequestsHelper
  include LocationFunctions
  include FilterRestrictions
  include GigRequestFunctions
  include BeforeDestroyFunctions
  include ApplicationHelper
  #search
  searchkick locations: [:location], language: "spanish", word_start: [:name, :description, :profession, :tags], suggest: [:name, :description, :profession, :tags]
  def search_data
    {
      #always first remove emojis and then special chars, otherwise there will be rare bugs with symbols inside string when sending to searchkick
      name: no_multi_spaces(remove_nexus(I18n.transliterate(no_special_chars(RemoveEmoji::Sanitize.call(name)).downcase))).strip,
      description: no_multi_spaces(remove_nexus(I18n.transliterate(no_special_chars(RemoveEmoji::Sanitize.call(description)).downcase))).strip,
      tags: tag_list.join(" "),
      category_id: category_id,
      status: status,
      user_id: user_id,
      price: budget[/\d+/].to_i, #finds first number
      profession: profession,
      created_at: created_at
     }.merge(location: {lat: lat, lon: lng})
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
  validates_presence_of :name, :description, :budget, :category_id, :lat, :lng
  validate  :tag_length, :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :profession, :maximum => 50, :message => "debe contener como máximo 50 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  validate :budget_options
  validate :invalid_change, on: :update
  validate :finished_request, on: :update
  validate :refund_money, if: :interrupting_request?, on: :update
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
      act_order = passed_active_order || self.active_order
      @success = act_order.update(status: "refund_in_progress", c_user: c_user)
      if @success && payment_success_and_employee_not_active
        create_notification(act_order.employee, act_order.employer, "El talento", act_order, "purchases")
      elsif ! @success# cant update order so i trigger that error
        errors.add(:base, act_order.errors.full_messages.first)
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
    to_upcase(self.name)
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
    all_orders = Order.where(employer_id: self.user_id, purchase: request_offers)
  end
end

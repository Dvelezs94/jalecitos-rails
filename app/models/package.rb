class Package < ApplicationRecord
  include LinksHelper
  attr_accessor :gig_required
  #Slug
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :gig, optional: true
  #Custom fields
  enum pack_type: { basic: 0, standard: 1, premium: 2}
  enum unit_type: { piece: 0, dozen: 1, centimeter: 2, meter: 3, kilometer: 4, sec: 5, minute: 6, hour: 7, day: 8, unit: 9, square_centimeter: 10, square_meter: 11, gram: 12, kilogram: 13, milliliter: 14, liter: 15, hundred: 16, thousand: 17 }

  # Orders association
  has_many :orders, as: :purchase

  #Validations
  validates_presence_of :gig, if: -> { gig_required != false } #when validating all, i dont need validate the presence of gig
  validates_presence_of :name, :description, :price, if: -> { name.present? || description.present? || price.present? } #empty packages doesnt validate prescence of nothing
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."

  validates_presence_of :unit_type, :min_amount, :max_amount, if: -> { unit_type.present? || min_amount.present? || max_amount.present? }
  validates :min_amount, numericality: { only_integer: true,   greater_than_or_equal_to: 1, allow_nil: true } #minimum 1 and allow not present

  validate :price_range, :min_and_max #:max_unit_price, no hire
  before_update :check_orders
  before_save :update_lowest_price_of_gig_and_publish

  def update_lowest_price_of_gig_and_publish
    if pack_type == "basic" && new_record? && self.gig.user.active? #now we dont index packages, so be careful, if you want to index info of packages, when this is triggered, package 2 and 3 are not created
      self.gig.update(lowest_price: lowest_price, status: "published")
      GigMailer.need_indexing(self.gig).deliver if ENV.fetch("RAILS_ENV") == "production"
    elsif pack_type == "basic"
      self.gig.update(lowest_price: lowest_price) if pack_type == "basic" #put to gig the price of first package
    end
  end

  def safe_description
    make_links(CGI::escapeHTML(self.description)).html_safe #escapes html from user and make our links
  end
  def lowest_price #if units, need to multiply for the lowest
    min_amount.present? ? price*min_amount : price
  end
  private
  def check_orders
    if self.orders.where(status: [:in_progress, :pending, :disputed]).limit(1).any?
      throw :abort
    end
  end



  def max_unit_price
    if unit_type.present? && min_amount.present? && max_amount.present? #unit type
      err = "La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN" if price * max_amount > 10000
    end

    if err
      errors.add(:base, "La cantidad máxima de unidades a vender multiplicadas por su precio unitario supera los 10,000 MXN")
    end
  end

  def price_range
    if unit_type.present? && min_amount.present? && max_amount.present? #unit type
      err = "El precio es demasiado bajo o no se proporcionó" if price < 1
      #err = "No puedes ganar arriba de 5000 MXN por unidad" if price > 5000 #no hire
    elsif price.present? #service type
      err = "El precio es demasiado bajo o no se proporcionó" if price < 100
      #err = "No puedes ganar arriba de 10000 MXN" if price > 10000 #no hire
    end

    if err
      errors.add(:base, err)
    end
  end

  def min_and_max
    if min_amount.present? && max_amount.present? && min_amount >= max_amount
      errors.add(:base, "El mínimo de unidades debe ser menor al mayor número de unidades")
    end
  end
  # def should_generate_new_friendly_id? #this generates a bug when goes back to edit, the package doesnt have same slug and nothing happens when send
  #   name_changed?
  # end
end

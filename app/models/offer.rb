class Offer < ApplicationRecord
  #Includes
  include FilterRestrictions
  #Associations
  belongs_to :user
  #counter_cache automatically increments and decrements offers_count in requests
  belongs_to :request, counter_cache: true
  has_one :payment
  has_many :orders, as: :purchase
  #Validations
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  #numericallity also allows its prescence unless if allow nil
  validates :price, numericality: { greater_than_or_equal_to: 100, less_than_or_equal_to: 10000 }
  validates :hours, numericality: { only_integer: true,   greater_than_or_equal_to: 1, allow_nil: true }
  validate :cant_edit, if: :has_order, on: :update

  def description=(val)
    write_attribute(:description, no_multi_spaces(val.strip))
  end

  def cant_edit
    errors.add(:base, "No puedes editar tu oferta ya que pertenece a una orden")
  end

  def destroy
    raise "No puedes borrar tu oferta ya que pertenece a una orden" if has_order #cant erase offer because maybe its being validating payment or working with that order.
    # ... ok, go ahead and destroy
    super
  end
  private
  def has_order
    order = Order.where(purchase_type: "Offer", purchase_id: self.id).where.not(status: "denied").limit(1).first
    return order.present?
  end
end

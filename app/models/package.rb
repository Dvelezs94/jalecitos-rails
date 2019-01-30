class Package < ApplicationRecord
  #Slug
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :gig
  #Custom fields
  enum pack_type: { basic: 0, standard: 1, premium: 2}

  # Orders association
  has_many :orders, as: :purchase

  before_update :check_orders

  def check_orders
    if self.orders.where(status: [:in_progress, :pending, :disputed]).limit(1).any?
      throw :abort
    else
      true
    end
  end
end

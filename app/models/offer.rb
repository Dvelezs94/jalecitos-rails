class Offer < ApplicationRecord
  #Includes
  include DescriptionRestrictions
  #Associations
  belongs_to :user
  belongs_to :request
  has_one :payment
  #Validations
  validate :description_length, :count_without_html
  #numericallity also allows its prescence unless if allow nil
  validates :price, numericality: { greater_than_or_equal_to: 100 }
  validates :hours, numericality: { only_integer: true,   greater_than_or_equal_to: 1, allow_nil: true }
end

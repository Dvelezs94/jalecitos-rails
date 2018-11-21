class Offer < ApplicationRecord
  #Includes
  include DescriptionRestrictions
  #Associations
  belongs_to :user
  belongs_to :request
  has_one :payment
  #Validations
  validate :description_length, :count_without_html
  validates :price, numericality: { greater_than_or_equal_to: 100 }
end

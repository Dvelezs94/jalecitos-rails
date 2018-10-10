class Package < ApplicationRecord
  belongs_to :gig
  validates_presence_of :type, :name, :description, :price
end

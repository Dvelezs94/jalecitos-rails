class Category < ApplicationRecord
  has_many :gigs
  validates_uniqueness_of :name
end

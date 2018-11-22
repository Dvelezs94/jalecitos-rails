class Category < ApplicationRecord
  has_many :gigs
  validates_uniqueness_of :name, message: "Ya hay una disputa para esta orden"
end

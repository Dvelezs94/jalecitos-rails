class State < ApplicationRecord
  has_many :cities
  belongs_to :country
end

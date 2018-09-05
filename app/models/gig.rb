class Gig < ApplicationRecord
  belongs_to :users
  belongs_to :categories
  has_and_belongs_to_many :tags
end

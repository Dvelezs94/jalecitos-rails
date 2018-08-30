class Gig < ApplicationRecord
  belongs_to :users
  belongs_to :categories
end

class Review < ApplicationRecord
  belongs_to :order
  belongs_to :user
  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'
end

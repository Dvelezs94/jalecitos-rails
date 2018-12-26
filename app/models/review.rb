class Review < ApplicationRecord
  #search
  searchkick language: "spanish"

  def search_data
    {
      user_id: user_id,
      status: status
    }
  end

  belongs_to :order
  belongs_to :user
  # Options to rate
  ratyrate_rateable 'Employee', 'Employer'
  enum status: { pending: 0, completed: 1 }
end

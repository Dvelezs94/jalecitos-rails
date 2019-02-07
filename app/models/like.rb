class Like < ApplicationRecord
  #search
  searchkick language: "spanish"
  def search_data
    {
      user_id: user_id,
      gig_id: gig_id,
      created_at: created_at
     }
  end
  belongs_to :user
  belongs_to :gig

end

class Like < ApplicationRecord
  # #search
  #callbacks false make sync off so records are not added automatically
   searchkick language: "spanish",callbacks: false
  # def search_data
  #   {
  #     user_id: user_id,
  #     gig_id: gig_id,
  #     created_at: created_at
  #    }
  # end
  belongs_to :user
  belongs_to :gig

end

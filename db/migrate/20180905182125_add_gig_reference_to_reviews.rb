class AddGigReferenceToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :gigs, foreign_key: true
  end
end

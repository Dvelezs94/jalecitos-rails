class AddGigToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :gig_id, :integer
  end
end

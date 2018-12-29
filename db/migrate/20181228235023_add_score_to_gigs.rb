class AddScoreToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :score, :integer
  end
end

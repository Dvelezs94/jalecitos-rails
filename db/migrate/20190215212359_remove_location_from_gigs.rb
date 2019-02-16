class RemoveLocationFromGigs < ActiveRecord::Migration[5.2]
  def change
    remove_column :gigs, :location, :string
  end
end

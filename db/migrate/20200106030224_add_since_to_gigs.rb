class AddSinceToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :since, :float
  end
end

class AddLatAndLngToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :lat, :float
    add_column :gigs, :lng, :float
    add_column :gigs, :address_name, :string
  end
end

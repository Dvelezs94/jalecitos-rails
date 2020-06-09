class AddLatAndLngToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :lat, :float
    add_column :requests, :lng, :float
    add_column :requests, :address_name, :string
  end
end

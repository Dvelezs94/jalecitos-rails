class RemoveLocationFromRequests < ActiveRecord::Migration[5.2]
  def change
    remove_column :requests, :location, :string
  end
end

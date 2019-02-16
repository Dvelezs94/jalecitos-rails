class AddCityToRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :requests, :city, foreign_key: true
  end
end

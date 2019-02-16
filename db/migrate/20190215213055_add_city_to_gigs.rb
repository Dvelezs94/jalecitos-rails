class AddCityToGigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :gigs, :city, foreign_key: true
  end
end

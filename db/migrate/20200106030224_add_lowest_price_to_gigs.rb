class AddLowestPriceToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :lowest_price, :float
  end
end

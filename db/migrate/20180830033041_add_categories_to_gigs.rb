class AddCategoriesToGigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :gigs, :category, foreign_key: true
  end
end

class CreateGigs < ActiveRecord::Migration[5.2]
  def change
    create_table :gigs do |t|
      t.string :name
      t.string :description
      t.string :location
      t.integer :order_count, default: 0

      t.timestamps
    end
  end
end

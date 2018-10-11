class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :description
      t.float :price
      t.references :request, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end

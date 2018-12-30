class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :comment
      t.integer :receiver_id
      t.integer :giver_id
      t.timestamps
    end
    add_index :reviews, [:receiver_id, :giver_id]
  end
end

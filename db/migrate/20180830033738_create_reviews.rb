class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.float :stars
      t.string :comment

      t.timestamps
    end
  end
end

class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :openpay_id
      t.integer :cvv
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

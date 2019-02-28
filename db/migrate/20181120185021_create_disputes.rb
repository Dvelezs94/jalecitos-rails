class CreateDisputes < ActiveRecord::Migration[5.2]
  def change
    create_table :disputes do |t|
      t.references :order, foreign_key: true, unique: true
      t.integer :status, default: 0
      t.string :description

      t.timestamps
    end
  end
end

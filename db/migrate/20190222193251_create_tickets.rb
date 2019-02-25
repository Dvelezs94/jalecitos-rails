class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :title
      t.string :description
      t.integer :priority
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.string :image
      t.integer :turn, default: 0

      t.timestamps
    end
  end
end

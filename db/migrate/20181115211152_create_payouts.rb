class CreatePayouts < ActiveRecord::Migration[5.2]
  def change
    create_table :payouts do |t|
      t.string :transaction_id
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.string :bank_id

      t.timestamps
    end
  end
end

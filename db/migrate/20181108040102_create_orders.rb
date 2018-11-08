class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.float :total
      t.integer :openpay_card
      t.string :purchase_type
      t.integer :purchase_id
      t.integer :status, default: 0
      t.string :payment_message

      t.timestamps
    end
  end
end

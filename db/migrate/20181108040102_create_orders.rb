class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.float :total
      t.integer :card_id
      t.string :purchase_type
      t.integer :purchase_id
      t.integer :status, default: 0
      t.string :payment_message
      t.string :response_order_id
      t.integer :receiver
      t.integer :code

      t.timestamps
    end
  end
end

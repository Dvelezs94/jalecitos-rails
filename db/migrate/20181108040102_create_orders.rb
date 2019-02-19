class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :employer_id
      t.float :total
      t.integer :card_id
      t.string :purchase_type
      t.integer :purchase_id
      t.integer :status, default: 0
      t.string :payment_message
      t.string :response_order_id
      t.integer :employee_id
      t.datetime :started_at
      t.datetime :completed_at
      t.string :paid_at
      t.string :uuid

      t.timestamps
    end
    add_index :orders, [:employer_id, :employee_id]
  end
end

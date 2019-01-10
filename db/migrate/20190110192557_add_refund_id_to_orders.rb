class AddRefundIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :response_refund_id, :string
    add_column :orders, :response_completion_id, :string
  end
end

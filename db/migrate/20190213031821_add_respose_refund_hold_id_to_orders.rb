class AddResposeRefundHoldIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :response_refund_hold_id, :string
  end
end

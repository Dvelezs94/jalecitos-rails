class AddPayoutLeftPendingToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :payout_left, :float
  end
end

class AddWithdrawalsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :withdrawal, foreign_key: true
  end
end

class AddPayoutsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :payout, foreign_key: true
  end
end

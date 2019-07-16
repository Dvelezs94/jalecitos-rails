class AddPaymentVerificationToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :payment_verification, :integer, default: 0
  end
end

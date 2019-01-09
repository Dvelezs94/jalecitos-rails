class AddBillingProfileToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :billing_profile, foreign_key: true
    add_column :orders, :invoice_status, :integer
    add_column :orders, :invoice_id, :string
  end
end

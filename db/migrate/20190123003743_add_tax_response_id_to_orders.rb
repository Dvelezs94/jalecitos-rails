class AddTaxResponseIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :response_tax_id, :string
  end
end

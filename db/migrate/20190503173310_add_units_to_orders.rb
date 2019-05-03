class AddUnitsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :unit_type, :string
    add_column :orders, :unit_count, :integer
  end
end

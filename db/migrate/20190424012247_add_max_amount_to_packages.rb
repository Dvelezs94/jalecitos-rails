class AddMaxAmountToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :max_amount, :integer
    add_column :packages, :min_amount, :integer
    add_column :packages, :unit_type, :integer
  end
end

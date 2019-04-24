class AddMaxAmountToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :max_amount, :integer
  end
end

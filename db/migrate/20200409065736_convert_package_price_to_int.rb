class ConvertPackagePriceToInt < ActiveRecord::Migration[5.2]
  def change
    change_column :packages, :price, :integer
  end
end

class AddUnitTypeToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :unit_type, :integer
  end
end

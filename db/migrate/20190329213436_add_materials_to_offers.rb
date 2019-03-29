class AddMaterialsToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :materials, :boolean, default: true
  end
end

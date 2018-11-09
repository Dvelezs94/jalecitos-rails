class AddSlugToPackage < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :slug, :string
    add_index :packages, :slug, unique: true
  end
end

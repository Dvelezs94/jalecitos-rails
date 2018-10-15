class AddSlugToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :slug, :string
    add_index :requests, :slug, unique: true
  end
end

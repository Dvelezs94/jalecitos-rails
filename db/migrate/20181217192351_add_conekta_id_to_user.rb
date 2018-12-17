class AddConektaIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :conekta_id, :string
    add_index :users, :conekta_id, unique: true
  end
end

class AddRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles, :string
    add_column :users, :alias, :string, unique: true
    add_column :users, :balance, :float, default: 0
  end
end

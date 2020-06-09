class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birth, :date
    add_column :users, :website, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
  end
end

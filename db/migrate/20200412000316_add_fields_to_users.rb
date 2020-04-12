class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :birth, :date
    add_column :users, :website, :string
  end
end

class AddFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :employee_stars, :float
    add_column :users, :employer_stars, :float
  end
end

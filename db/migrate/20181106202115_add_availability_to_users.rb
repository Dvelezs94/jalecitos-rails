class AddAvailabilityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :available, :string
  end
end

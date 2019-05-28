class AddCauseToBans < ActiveRecord::Migration[5.2]
  def change
    add_column :bans, :cause, :integer
  end
end

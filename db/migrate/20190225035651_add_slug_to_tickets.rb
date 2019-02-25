class AddSlugToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :slug, :string
    add_index :tickets, :slug, unique: true
  end
end

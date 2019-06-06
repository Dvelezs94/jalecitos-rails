class AddBannedByIdToBans < ActiveRecord::Migration[5.2]
  def change
    add_column :bans, :banned_by_id, :integer
    add_index :bans, :banned_by_id
  end
end

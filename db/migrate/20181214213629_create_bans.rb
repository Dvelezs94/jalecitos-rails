class CreateBans < ActiveRecord::Migration[5.2]
  def change
    create_table :bans do |t|
      t.integer :status, default: 0
      t.string :baneable_type
      t.integer :baneable_id
      t.string :comment

      t.timestamps
    end
  end
end

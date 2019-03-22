class AddLevelToPayouts < ActiveRecord::Migration[5.2]
  def change
    add_column :payouts, :level, :integer
  end
end

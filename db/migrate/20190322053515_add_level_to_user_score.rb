class AddLevelToUserScore < ActiveRecord::Migration[5.2]
  def change
    add_column :user_scores, :level, :integer, default: 1
  end
end

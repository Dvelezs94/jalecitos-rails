class AddOrdersCountToUserScore < ActiveRecord::Migration[5.2]
  def change
    add_column :user_scores, :sales_count, :integer, default: 0
  end
end

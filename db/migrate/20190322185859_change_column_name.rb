class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_scores, :sales_count, :total_sales
  end
end

class ChangeTotalScoreToFloatInUserScores < ActiveRecord::Migration[5.2]
  def change
    change_column :user_scores, :total_sales, :float
  end
end

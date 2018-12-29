class CreateUserScores < ActiveRecord::Migration[5.2]
  def change
    create_table :user_scores do |t|
      t.references :user, foreign_key: true
      t.float :employer_score_average, default: 0
      t.float :employee_score_average, default: 0
      t.integer :employer_score_times, default: 0
      t.integer :employee_score_times, default: 0

      t.timestamps
    end
  end
end

class AddScoreToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :score_average, :float, default: 0
    add_column :gigs, :score_times, :integer, default: 0
  end
end

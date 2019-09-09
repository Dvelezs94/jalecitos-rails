class AddRecomendationToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :recomendation, :boolean, default: false
  end
end

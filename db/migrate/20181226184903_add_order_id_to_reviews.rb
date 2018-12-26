class AddOrderIdToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :order, foreign_key: true
  end
end

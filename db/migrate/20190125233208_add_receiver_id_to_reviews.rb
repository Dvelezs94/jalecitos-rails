class AddReceiverIdToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :receiver_id, :integer
  end
end

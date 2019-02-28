class AddOfferCountToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :offers_count, :integer, default: 0
  end
end

class AddStatusToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :status, :integer, default: 0
  end
end

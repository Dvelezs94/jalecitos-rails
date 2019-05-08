class AddVisitsToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :visits, :integer, default: 0
  end
end

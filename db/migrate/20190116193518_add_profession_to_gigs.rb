class AddProfessionToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :profession, :string
  end
end

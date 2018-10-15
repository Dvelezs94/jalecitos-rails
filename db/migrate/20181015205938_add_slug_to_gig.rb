class AddSlugToGig < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :slug, :string
    add_index :gigs, :slug, unique: true
  end
end

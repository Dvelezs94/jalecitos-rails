class AddSeoToGigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :gigs, :seo, foreign_key: true
  end
end

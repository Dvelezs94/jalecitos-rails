class AddTagsToGigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :gigs, :tag, foreign_key: true
  end
end

class CreateTagsGigsJoinTable < ActiveRecord::Migration[5.2]
  def change
   # If you want to add an index for faster querying through this join:
  create_join_table :tags, :gigs do |t|
    end
  end
end
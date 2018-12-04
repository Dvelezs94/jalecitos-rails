class AddMultiUploadToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :images, :json
  end
end

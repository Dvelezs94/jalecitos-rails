class AddImagesToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :images, :json
  end
end

class AddImagesToDisputes < ActiveRecord::Migration[5.2]
  def change
    add_column :disputes, :images, :json
  end
end

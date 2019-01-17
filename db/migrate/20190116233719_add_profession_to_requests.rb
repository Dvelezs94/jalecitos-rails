class AddProfessionToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :profession, :string
  end
end

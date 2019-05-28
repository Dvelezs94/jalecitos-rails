class AddAllyCodesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :ally_code, foreign_key: true
  end
end

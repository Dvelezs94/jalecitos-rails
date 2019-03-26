class AddRelatedToToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :related_to_id, :integer
    add_column :messages, :related_to_type, :string
  end
end

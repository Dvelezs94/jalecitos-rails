class AddPhoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :whatsapp_enabled, :boolean, default: false
  end
end

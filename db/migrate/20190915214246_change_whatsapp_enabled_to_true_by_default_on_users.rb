class ChangeWhatsappEnabledToTrueByDefaultOnUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :whatsapp_enabled, :boolean, :default => true
  end
end

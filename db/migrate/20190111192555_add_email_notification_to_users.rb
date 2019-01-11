class AddEmailNotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :transactional_emails, :boolean, default: true
    add_column :users, :marketing_emails, :boolean, default: true
  end
end

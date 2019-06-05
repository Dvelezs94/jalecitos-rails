class AddFiltersToMarketingNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :marketing_notifications, :filters, :string
  end
end

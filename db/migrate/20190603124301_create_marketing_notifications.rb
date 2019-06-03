class CreateMarketingNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :marketing_notifications do |t|
      t.string :name
      t.string :content
      t.datetime :scheduled_at
      t.integer :status, default: 0
      t.string :url

      t.timestamps
    end
  end
end

class AddDeviceToPushSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :push_subscriptions, :device, :string, default: ""
  end
end

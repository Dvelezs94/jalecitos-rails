class CreatePushSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :push_subscriptions do |t|
      t.references :user, foreign_key: true
      t.string :auth_key, unique: true

      t.timestamps
    end
  end
end

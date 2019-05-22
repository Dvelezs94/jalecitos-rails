class CreateAllyCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :ally_codes do |t|
      t.string :token, unique: true
      t.integer :times_left, default: 1
      t.boolean :enabled, default: true
      t.string :name, required: true
      t.boolean :level_enabled, default: false

      t.timestamps
    end
  end
end

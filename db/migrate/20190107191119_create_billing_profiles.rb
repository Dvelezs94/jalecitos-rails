class CreateBillingProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_profiles do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :rfc
      t.integer :zip_code
      t.integer :status, default: 0
      t.string :address

      t.timestamps
    end
  end
end

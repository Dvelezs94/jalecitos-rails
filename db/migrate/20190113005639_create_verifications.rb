class CreateVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :verifications do |t|
      t.references :user, foreign_key: true
      t.json :identification
      t.string :curp
      t.string :address
      t.string :criminal_letter
      t.integer :status, default: 0
      t.string :denial_details

      t.timestamps
    end
  end
end

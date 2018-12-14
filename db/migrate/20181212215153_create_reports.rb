class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.string :reportable_type
      t.integer :reportable_id
      t.integer :status, default: 0
      t.string :cause
      t.string :comment

      t.timestamps
    end
  end
end

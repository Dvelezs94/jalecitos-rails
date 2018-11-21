class CreateReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :replies do |t|
      t.references :dispute, foreign_key: true
      t.string :message
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :description
      t.references :category, foreign_key: true
      t.string :budget
      t.string :image
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

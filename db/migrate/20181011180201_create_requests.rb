class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.string :description
      t.references :category, foreign_key: true
      t.float :budget
      t.string :image
      t.string :location
      t.string :status

      t.timestamps
    end
  end
end

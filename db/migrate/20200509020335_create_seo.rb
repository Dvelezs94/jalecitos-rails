class CreateSeo < ActiveRecord::Migration[5.2]
  def change
    create_table :seos do |t|
      t.string :title
      t.string :keywords
      t.string :description
    end
  end
end

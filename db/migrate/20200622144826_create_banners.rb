class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.string :image
      t.integer :display, :default => 0
      t.timestamps
    end
  end
end

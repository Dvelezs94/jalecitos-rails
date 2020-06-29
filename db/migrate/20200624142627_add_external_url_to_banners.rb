class AddExternalUrlToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :external_url, :boolean, :default => false
  end
end

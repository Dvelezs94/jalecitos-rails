class AddSeoToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :seo_title, :string
    add_column :categories, :seo_description, :string
    add_column :categories, :seo_keywords, :string
  end
end

class AddPhoneToGigs < ActiveRecord::Migration[5.2]
  def change
    add_column :gigs, :phone_number, :string
  end
end

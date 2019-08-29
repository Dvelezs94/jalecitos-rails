class AddPhoneToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :phone_number, :string
  end
end

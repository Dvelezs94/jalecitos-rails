class AddOffersToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :offer, foreign_key: true
  end
end

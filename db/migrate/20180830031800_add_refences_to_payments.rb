class AddRefencesToPayments < ActiveRecord::Migration[5.2]
  def change
    add_reference :payments, :user, foreign_key: true
    add_reference :payments, :package, foreign_key: true
  end
end

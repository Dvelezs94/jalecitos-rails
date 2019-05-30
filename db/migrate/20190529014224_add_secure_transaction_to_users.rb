class AddSecureTransactionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :secure_transaction, :boolean, default: false
    add_column :users, :secure_transaction_job_id, :string
  end
end

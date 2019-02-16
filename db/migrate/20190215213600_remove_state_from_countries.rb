class RemoveStateFromCountries < ActiveRecord::Migration[5.2]
  def change
    remove_reference :countries, :state, foreign_key: true
  end
end

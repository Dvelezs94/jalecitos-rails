class AddCountryToStates < ActiveRecord::Migration[5.2]
  def change
    add_reference :states, :country, foreign_key: true
  end
end

class AddGigsToExtras < ActiveRecord::Migration[5.2]
  def change
    add_reference :extras, :gigs, foreign_key: true
  end
end

class AddGigsToExtras < ActiveRecord::Migration[5.2]
  def change
    add_reference :extras, :gig, foreign_key: true
  end
end

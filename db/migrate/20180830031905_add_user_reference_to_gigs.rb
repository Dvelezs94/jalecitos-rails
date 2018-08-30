class AddUserReferenceToGigs < ActiveRecord::Migration[5.2]
  def change
    add_reference :gigs, :user, foreign_key: true
  end
end

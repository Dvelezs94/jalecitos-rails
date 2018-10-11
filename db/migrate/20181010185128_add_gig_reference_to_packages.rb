class AddGigReferenceToPackages < ActiveRecord::Migration[5.2]
  def change
    add_reference :packages, :gig, foreign_key: true
  end
end

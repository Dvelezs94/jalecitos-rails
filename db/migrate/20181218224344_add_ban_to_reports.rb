class AddBanToReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :ban, foreign_key: true
  end
end

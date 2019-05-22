class AddCauseIntegerToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :cause, :integer
  end
end

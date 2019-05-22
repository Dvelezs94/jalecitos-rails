class ChangeCauseNameOfReports < ActiveRecord::Migration[5.2]
  def change
    rename_column :reports, :cause, :cause_str
  end
end

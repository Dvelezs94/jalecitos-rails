class AddEmployeeToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :employee_id, :integer
  end
end

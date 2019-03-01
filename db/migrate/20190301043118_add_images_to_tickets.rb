class AddImagesToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :images, :json
  end
end

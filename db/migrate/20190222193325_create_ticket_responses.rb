class CreateTicketResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_responses do |t|
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true
      t.string :message
      t.string :image

      t.timestamps
    end
  end
end

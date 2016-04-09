class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :location	
      t.string :balance

      t.timestamps null: false
    end

    add_reference :users, :client
    add_reference :bookings, :client

  end
end

class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
    	t.string :name
    	t.string :location
    	t.integer :days
    	t.datetime :start_date
    	t.datetime :end_date
    	t.string :status

    	t.timestamps
    end

    add_column :bookings, :user_id, :integer
    add_column :bookings, :vendor_id, :integer
  end
end

class AddRepToBooking < ActiveRecord::Migration
  def change
  	add_column :bookings, :rep_id, :integer
  end
end
